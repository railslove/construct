class Build < ActiveRecord::Base
  LOGGER = Logger.new("#{RAILS_ROOT}/log/builds.log")
  default_scope :order => "builds.created_at DESC"
  serialize :payload, Hash
  belongs_to :commit
  
  before_create :increment_number
  
  delegate :project, :to => :commit
  delegate :branch, :to => :commit
  
  named_scope :queued, :conditions => { :status => "queued" }
  
  named_scope :in_progress_excluding, lambda { |build| { :conditions => ["status != 'success' AND status != 'failed' AND builds.id != ?", build.id] } }
  
  named_scope :before, lambda { |build| { :conditions => ["builds.created_at < ?", build.created_at]}}
  named_scope :after,  lambda { |build| { :conditions => ["builds.created_at > ?", build.created_at]}}
  
  # For storing notifications such as if a build for this project is already in progress.
  attr_accessor :notifications
  
  # We want it to be an array by default
  def notifications 
    @notifications ||= []
  end
  
  class AlreadyQueued < StandardError
  end
  
  class << self
    
    # Prepare a build to be built.
    def setup(payload)
      if self == Build
        raise "Setup must be called on a subclass of Build (GithubBuild or CodebaseBuild)"
      end
      payload = JSON.parse(payload) if payload.is_a?(String)
      project, commit = Project.from_payload(self, payload)
      build = Build.create!(:payload => payload,
                            :commit => commit, 
                             :status => "queued", 
                             :instructions => project.instructions, 
                             :site =>  site)
    end
    
    # Helper method:
    # Rather than calling setup(payload).start we can just call start(payload)
    def start(payload)
      setup(payload).start
    end
  end
  
  def update_status(status)
    LOGGER.info "Build ##{id}: #{status}"
    update_attribute(:status, status)
  end
  
  def start
    return self if status == 'failed' || status == 'success'
    # in_progress_builds = project.builds.in_progress_excluding(self)
    # if in_progress_builds.empty?
      Delayed::Job.enqueue(BuildJob.new(id, payload))
    # else
    #   builds = project.builds.all(:select => "builds.id")
    #   queue_number = builds.index(in_progress_builds.first) - builds.index(self)
    #   self.notifications << "Another build for this project is currently in progress. This build is ##{queue_number} in the build queue for this project."
    #   update_status("waiting")
    # end
    self
  end
  
  def github?
    site == "github.com"
  end
  
  def codebase?
    site == "codebasehq.com"
  end

  
  def successful?
    status == "success"
  end
  
  def pending?
    %w(queued waiting).include?(status)
  end
  
  def failed?
    status == "failed"
  end
  
  def finished?
    failed? || successful?
  end
  
  def to_s
    commit.short_sha
  end
  
  def to_param
    "#{id}-#{commit.short_sha}"
  end
  
  # Trigger a rebuild.
  def rebuild
    klass = github? ? GithubBuild : CodebaseBuild
    klass.start(payload)
  end
  
  def report
    if successful?
      "successful"
    elsif ["setting up repository", "running the build", "queued", "waiting", "stalled"].include?(status)
      status
    else
      "failed"
    end
  end
  
  def simple_status
    case status
    when /fail/, "branch already exists", "stalled"
      "failed"
    when /success$/
      "success"
    else
      "building"
    end
  end
  
  private
  
  def increment_number
    self.number = commit.builds.count
  end
end

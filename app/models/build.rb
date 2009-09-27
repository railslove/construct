class Build < ActiveRecord::Base
  default_scope :order => "created_at DESC"
  serialize :payload, Hash
  belongs_to :commit
  
  before_create :increment_number
  
  delegate :project, :to => :commit
  delegate :branch, :to => :commit
  
  named_scope :before, lambda { |build| { :conditions => ["created_at < ?", build.created_at]}}
  named_scope :after,  lambda { |build| { :conditions => ["created_at > ?", build.created_at]}}
  
  class AlreadyQueued < StandardError
  end
  
  class << self
    
    # Prepare a build to be built.
    def setup(payload)
      if self == Build
        raise "Setup must be called on a subclass of Build (GithubBuild or CodebaseBuild)"
      end
      project, commit = Project.from_payload(self, payload)
      build = Build.create!(:payload => payload,
                            :commit => commit, 
                             :status => "queued", 
                             :instructions => project.instructions, 
                             :site =>  site)
    end
  end
  
  def start
    # Trying to find if this build has already been queued.
    # The way we detect this for now is to inspect all the handlers of all current jobs.
    # This shouldn't be too many as jobs are cleared when they're done.
    for job in Delayed::Job.all
      if Build.find(YAML.load(job.handler.split("\n")[1..-1].join("\n"))["build_id"]).commit == commit
        destroy
        return false
      end
    end
    Delayed::Job.enqueue(BuildJob.new(id, payload))
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
  
  def to_s
    commit.short_sha
  end
  
  def to_param
    "#{id}-#{commit.short_sha}"
  end
  
  def rebuild
    klass = github? ? GithubBuild : CodebaseBuild
    klass.setup(payload).start
      
  end
  
  def report
    if successful?
      "successful"
    elsif status == "setting up repository" || status == "running the build" || status == "queued"
      status
    else
      "failed"
    end
  end
  
  private
  
  def increment_number
    self.number = commit.builds.count
  end
end

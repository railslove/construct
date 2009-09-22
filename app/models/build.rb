class Build < ActiveRecord::Base
  default_scope :order => "created_at DESC"
  serialize :payload, Hash
  belongs_to :commit
  
  before_create :increment_number
  
  delegate :project, :to => :commit
  
  named_scope :before, lambda { |build| { :conditions => ["created_at < ?", build.created_at]}}
  
  class << self
    def start(payload)
      first_commit = payload["commits"].first
      first_commit["sha"] = first_commit["id"]
      project      = Project.find_by_payload(payload)
      commit       = project.commits.find_by_sha(first_commit["sha"])
      commit     ||= project.commits.create!(first_commit)
      project      = commit.project
      build        = create!(:payload => payload, :commit => commit, :status => "queued")
      build_id     = build.id
      Delayed::Job.enqueue(BuildJob.new(build_id, payload))
      build
    end
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
    Build.start(payload)
  end
  
  def report
    if successful?
      "successfully"
    elsif status == "setting up repository" || status == "running the build" || status == "queued"
      status
    else
      "failed"
    end
  end
  
  private
  
  def increment_number
    logger.debug(p(self))
    self.number = commit.builds.count
  end
end

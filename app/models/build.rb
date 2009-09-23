class Build < ActiveRecord::Base
  default_scope :order => "created_at DESC"
  serialize :payload, Hash
  belongs_to :commit
  
  before_create :increment_number
  
  delegate :project, :to => :commit
  
  named_scope :before, lambda { |build| { :conditions => ["created_at < ?", build.created_at]}}
  
  class AlreadyQueued < StandardError
  end
  
  class << self
    def start(payload)
      p self
      first_commit = payload["commits"].first
      first_commit["sha"] = first_commit["id"]
      project      = Project.find_or_create_by_payload_and_site(payload, "codebasehq.com")
      commit       = project.commits.find_by_sha(first_commit["sha"])
      commit     ||= project.commits.create!(first_commit)
      project      = commit.project
      build        = Build.create!(:payload => payload,
                             :commit => commit, 
                             :status => "queued", 
                             :instructions => project.instructions, 
                             :site => "codebasehq.com"
                             )
      build_id     = build.id
      # Trying to find if this build has already been queued.
      # The way we detect this for now is to inspect all the handlers of all current jobs.
      for job in Delayed::Job.all
        if Build.find(YAML.load(job.handler.split("\n")[1..-1].join("\n"))["build_id"]).commit == commit
          build.errors.add_to_base "This commit is already queued to build."
        end
      end
      Delayed::Job.enqueue(BuildJob.new(build_id, payload))
      build
      
    end
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
    klass = github? ? Build::Github : Build::Codebase
    Build::Github.start(payload)
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
    self.number = commit.builds.count
  end
end

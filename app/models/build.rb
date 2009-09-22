class Build < ActiveRecord::Base
  default_scope :order => "created_at DESC"
  
  belongs_to :commit
  class << self
    def start(payload)
      first_commit = payload["commits"].first
      first_commit["sha"] = first_commit["id"]
      project      = Project.find_by_payload(payload)
      commit       = project.commits.find_by_sha(first_commit["sha"])
      commit     ||= project.commits.create!(first_commit)
      project      = commit.project
      build        = create!(:payload => payload, :commit => commit)
      
      BuildJob.new(build, payload).perform
    end
  end
  
  def successful?
    status == "success"
  end
  
  def to_s
    commit.short_sha
  end
  
  def report
    successful? ? "successfully" : "failed"
  end
end

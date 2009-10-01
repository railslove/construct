class Project < ActiveRecord::Base
  belongs_to :author
  has_many :branches, :dependent => :destroy
  has_many :commits, :dependent => :destroy
  has_many :builds, :through => :commits
  
  validates_presence_of :name
  
  before_create :defaults
  before_save :set_permalink
  
  default_scope :order => "name"
  
  class << self
    def find_or_create_by_payload_and_site(payload, site)
      project = find_or_create_by_name(payload["repository"]["name"])
      project.build_directory = ERB.new(CONSTRUCTA["build_directory"]).result(binding) + "/" + if site == "github.com"
      project.site = site
        payload["repository"]["name"]
      elsif site == "codebasehq.com"
        payload["repository"]["clone_url"].split("/")[-2..-1].map { |part| part.gsub('.git', '') }.join("-")
      end
      project.save!
      project
    end
    
    def from_payload(build_type, payload)
      first_commit = payload["commits"].first
      first_commit["sha"] = first_commit["id"]
      site = build_type == GithubBuild ? "github.com" : "codebasehq.com"
      project       = Project.find_or_create_by_payload_and_site(payload, site)
      commit        = project.commits.find_by_sha(first_commit["sha"])
      commit      ||= project.commits.create!(first_commit)
      commit.branch = project.branches.find_or_create_by_name(payload["ref"].split("/").last)
      commit.save!
      project       = commit.project
      [project, commit]
    end
  end
  
  def to_param
    name.parameterize
  end
  
  def status
    branches.any? { |branch| branch.builds.first(:order => "created_at DESC").failed? } ? "failed" : "success"
  end
  
  
  private
  
  def defaults
    self.instructions = "rake" if instructions.blank?
  end
  
  def set_permalink
    self.permalink = name.parameterize
  end
  
end

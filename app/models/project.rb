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
      commits = []
      for commit in payload["commits"]
        commit["sha"] = commit["id"]
        site = build_type == GithubBuild ? "github.com" : "codebasehq.com"
        project           = Project.find_or_create_by_payload_and_site(payload, site)
        new_commit        = project.commits.find_by_sha(commit["sha"])
        new_commit      ||= project.commits.create!(commit)
        new_commit.branch = project.branches.find_or_create_by_name(payload["ref"].split("/").last)
        new_commit.save!
        project       = new_commit.project

        commits << new_commit
      end
      
      [project, commits]
    end
  end
  
  def to_param
    name.parameterize
  end
  
  def status
    if (statuses = branches.map { |branch| branch.builds.first(:order => "created_at DESC").simple_status }.uniq).size == 1
      statuses.first.underscore
    else
      'varying'
    end
  end
  
  def timeout
    self[:timeout] ||= 10.minutes
  end
  
  private
  
  def defaults
    self.instructions = "rake" if instructions.blank?
  end
  
  def set_permalink
    self.permalink = name.parameterize
  end
  
end

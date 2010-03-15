class Project < ActiveRecord::Base
  
  belongs_to :author
  has_many :branches, :dependent => :destroy
  has_many :commits, :dependent => :destroy
  has_many :builds, :through => :commits
  
  validates_presence_of :name
  
  before_create :defaults
  before_save :set_permalink
  before_destroy :delete_project_files
  
  default_scope :order => "name"
  
  class << self
    def find_or_create_by_payload_and_site(payload, site)
      project = find_or_create_by_name(payload["repository"]["name"])
      project.site ||= site
      if project.build_directory.blank?
        if site == "github.com"
          payload["repository"]["name"]
        elsif site == "codebasehq.com"
          payload["repository"]["clone_url"].split("/")[-2..-1].map { |part| part.gsub('.git', '') }.join("-")
        end
        project.build_directory = ERB.new( CONSTRUCT["build_directory"]).result(binding) + "/" + project.name
      end
      project.save!
      project
    end
    
    def from_payload(build_type, payload)
      first_commit = payload["commits"].last
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
    self.instructions = CONSTRUCT["default_build_instructions"] if instructions.blank?
  end
  
  def set_permalink
    self.permalink = name.parameterize
  end
  
  def delete_project_files
    FileUtils.rm_rf(build_directory)
  end
  
end

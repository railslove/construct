class Project < ActiveRecord::Base
  belongs_to :author
  has_many :commits
  has_many :builds, :through => :commits
  
  before_create :default_instructions
  
  class << self
    def find_or_create_by_payload_and_site(payload, site)
      project = find_or_create_by_name(payload["repository"]["name"]) 
      project.build_directory = "/data/builds/" + if site == "github.com"
      project.site = site
        payload["repository"]["name"]
      elsif site == "codebasehq.com"
        p payload["repository"]["clone_url"]
        payload["repository"]["clone_url"].split("/")[-2..-1].map { |part| part.gsub('.git', '') }.join("-")
      end
      project.save!
      project
    end
  end
  
  
  private
  
  def default_instructions
    self.instructions = "rake" if instructions.blank?
  end
  
end

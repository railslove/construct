class Project < ActiveRecord::Base
  belongs_to :author
  has_many :commits
  has_many :builds, :through => :commits
  
  before_create :default_instructions
  
  class << self
    def find_by_payload(payload)
      # May want to do more later
      find_or_create_by_name(payload["repository"]["name"]) 
    end
  end
  
  
  private
  
  def default_instructions
    self.instructions = "rake" if instructions.blank?
  end
  
end

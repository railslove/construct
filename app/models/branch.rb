class Branch < ActiveRecord::Base
  belongs_to :project
  has_many :commits
  has_many :builds, :through => :commits
  
  def to_param
    name
  end
  
  def to_s
    name
  end
end

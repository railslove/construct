class Branch < ActiveRecord::Base
  belongs_to :project
  has_many :commits
  has_many :builds, :through => :commits
end

class Channel < ActiveRecord::Base
  default_scope :order => "name"
  has_many :messages
  
  def to_param
    name
  end
end

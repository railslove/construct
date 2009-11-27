class Message < ActiveRecord::Base
  default_scope :order => "created_at ASC"
  belongs_to :channel, :touch => true
  belongs_to :person
end

class Commit < ActiveRecord::Base
  belongs_to :author, :class_name => "Person"
  belongs_to :project
  has_many :builds
  
  alias_method :old_author=, :author=
  
  def author=(params)
    self.old_author = Person.new(params)
  end
  
  def short_sha
    sha[0..8]
  end
end

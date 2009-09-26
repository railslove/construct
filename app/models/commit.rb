class Commit < ActiveRecord::Base
  belongs_to :author, :class_name => "Person"
  belongs_to :project
  belongs_to :branch
  has_many :builds, :dependent => :destroy
  
  alias_method :old_author=, :author=
  
  def author=(params)
    self.old_author = Person.new(params)
  end
  
  def short_sha
    sha[0..8]
  end
end

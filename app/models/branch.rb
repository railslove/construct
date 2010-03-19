class Branch < ActiveRecord::Base
  
  belongs_to :project
  has_many :commits, :dependent => :destroy
  has_many :builds, :through => :commits
  
  before_destroy :delete_branch_files
  
  def to_param
    name
  end
  
  def to_s
    name
  end
  
  def build_latest!
    path = File.join(project.build_directory, name)
    Dir.chdir(path) do
      `git checkout .`
      `git checkout #{name}`
      `git pull origin #{name}`
      klass = project.site == "github.com" ? GithubBuild : CodebaseBuild
      klass.setup(Payload.for(project.name, Grit::Repo.new(path), name, `git rev-parse HEAD`.strip)).start
    end
  end
  
  def delete_branch_files
    FileUtils.rm_rf( File.join(project.build_directory, name) )
  end
  
end

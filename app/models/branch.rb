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
end

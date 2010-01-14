class Payload
  # Takes a Grit::Repo object and a commit sha and builds a stripped down payload for the commit.
  # Only used by branch's build_latest for now.
  def self.for(name, repo, branch, id)
    commits = repo.commits_since(branch)
    commit = commits.detect { |c| c.id == id }
    index = commits.map(&:id).index(id)
    
    before = commits[index+1]
    after = commits[index-1] unless index == 0
    
    HashWithIndifferentAccess.new({
      :after => after ? after.sha : nil,
      :before => before.sha,
      :ref => "refs/heads/" + branch,
      :commits => [{
        :id => commit.id,
        :added => [],
        :author => {
          :email => commit.author.email,
          :name => commit.author.name,
        },
        :message => commit.message,
        :modified => [],
        :removed => [],
        :timestamp => commit.committed_date,
        :url => nil
      }],
      :repository => {
        :name => name
      }
    })
  end
end
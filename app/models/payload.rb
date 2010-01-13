class Payload
  # Takes a Grit::Repo object and a commit sha and builds a payload for the commit.
  # Only used by branch's build_latest for now.
  def self.for(name, repo, id)
    commit = repo.commits.detect { |c| c.id == id }
    p commit
    index = repo.commits.map(&:id).index(id)
    
    before = repo.commits[index+1]
    after = repo.commits[index-1] unless index == 0
    
    HashWithIndifferentAccess.new({
      :after => after ? after.sha : nil,
      :before => before.sha,
      :ref => "refs/heads/" + repo.refs.detect { |ref| ref.commit.id == commit.id }.name,
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
        :timestamp => commit.authored_date,
        :url => nil
      }],
      :repository => {
        :name => name
      }
    })
  end
end
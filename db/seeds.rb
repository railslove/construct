%w{
  construct-success
  construct-success-2
  docjockey
  rboard
  construct-success-branch
}.


each do |project|
  GithubBuild.start(JSON.parse(File.read(File.join(RAILS_ROOT,"spec/fixtures/#{project}"))))
end
class Notifier < ActionMailer::Base
  def build(build)
    notify = CONSTRUCT["email_notifications"]
    return "No email_notifications key in Construct config." if !notify
    
    recipients notify["to"]
    from       notify["from"]
    subject    "[construct] #{build.email_subject}! #{build.project.name} - #{build.commit.short_sha}"
    body       :build => build
    content_type "text/html"
  end
  
end
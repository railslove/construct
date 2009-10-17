require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  include ApplicationHelper
    
  
  class TestView < ActionView::Base
    include ApplicationHelper
    
    def controller=(controller)
      @controller = controller.new
      @controller.params = { :action => "page", :controller => "1"}
      @controller.request = 
      
      {"rack.session"=>{:session_id=>"9973a2bb305ec5651c7a3b993a9df231", "flash"=>{:notice=>"Applicant was successfully created."}, :_csrf_token=>"HeZu6BlXqIlbQhXi9PQjyVKq5PI2t4V2sZsJRt4idvA="}, "SERVER_NAME"=>"localhost", "HTTP_CACHE_CONTROL"=>"no-cache", "HTTP_ACCEPT"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "HTTP_HOST"=>"localhost:3000", "rack.request.cookie_hash"=>{"_nested_session"=>"BAh7CDoPc2Vzc2lvbl9pZCIlOTk3M2EyYmIzMDVlYzU2NTFjN2EzYjk5M2E5ZGYyMzEiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIihBcHBsaWNhbnQgd2FzIHN1Y2Nlc3NmdWxseSBjcmVhdGVkLgY6CkB1c2VkewY7B0Y6EF9jc3JmX3Rva2VuIjFIZVp1NkJsWHFJbGJRaFhpOVBRanlWS3E1UEkydDRWMnNac0pSdDRpZHZBPQ==--8b1b57e7487b3631b829abcbd9b87e7feee4fbb2"}, "rack.url_scheme"=>"http", "HTTP_KEEP_ALIVE"=>"300", "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3", "REQUEST_PATH"=>"/applicants/16", "rack.errors"=>#<IO:0x100163b80>, "SERVER_PROTOCOL"=>"HTTP/1.1", "HTTP_ACCEPT_LANGUAGE"=>"en-us,en;q=0.5", "rack.version"=>[0, 1], "rack.run_once"=>false, "REMOTE_ADDR"=>"127.0.0.1", "PATH_INFO"=>"/applicants/16", "SERVER_SOFTWARE"=>"Mongrel 1.1.5", "rack.request.cookie_string"=>"_nested_session=BAh7CDoPc2Vzc2lvbl9pZCIlOTk3M2EyYmIzMDVlYzU2NTFjN2EzYjk5M2E5ZGYyMzEiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIihBcHBsaWNhbnQgd2FzIHN1Y2Nlc3NmdWxseSBjcmVhdGVkLgY6CkB1c2VkewY7B0Y6EF9jc3JmX3Rva2VuIjFIZVp1NkJsWHFJbGJRaFhpOVBRanlWS3E1UEkydDRWMnNac0pSdDRpZHZBPQ%3D%3D--8b1b57e7487b3631b829abcbd9b87e7feee4fbb2", "rack.request"=>#<Rack::Request:0x102cc39b0 @env={...}>, "SCRIPT_NAME"=>"", "HTTP_REFERER"=>"http://localhost:3000/", "rack.multithread"=>false, "HTTP_COOKIE"=>"_nested_session=BAh7CDoPc2Vzc2lvbl9pZCIlOTk3M2EyYmIzMDVlYzU2NTFjN2EzYjk5M2E5ZGYyMzEiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIihBcHBsaWNhbnQgd2FzIHN1Y2Nlc3NmdWxseSBjcmVhdGVkLgY6CkB1c2VkewY7B0Y6EF9jc3JmX3Rva2VuIjFIZVp1NkJsWHFJbGJRaFhpOVBRanlWS3E1UEkydDRWMnNac0pSdDRpZHZBPQ%3D%3D--8b1b57e7487b3631b829abcbd9b87e7feee4fbb2", "HTTP_VERSION"=>"HTTP/1.1", "action_controller.request.path_parameters"=>{"action"=>"show", "id"=>"16", "controller"=>"applicants"}, "rack.multiprocess"=>true, "REQUEST_URI"=>"/applicants/16", "SERVER_PORT"=>"3000", "HTTP_ACCEPT_CHARSET"=>"ISO-8859-1,utf-8;q=0.7,*;q=0.7", "rack.session.options"=>{:path=>"/", :expire_after=>nil, :id=>"9973a2bb305ec5651c7a3b993a9df231", :httponly=>true, :domain=>nil, :key=>"_session_id"}, "REQUEST_METHOD"=>"GET", "QUERY_STRING"=>"", "rack.input"=>#<StringIO:0x102d4bfe0>, "GATEWAY_INTERFACE"=>"CGI/1.2", "HTTP_PRAGMA"=>"no-cache", "HTTP_CONNECTION"=>"keep-alive", "HTTP_ACCEPT_ENCODING"=>"gzip,deflate"}
    end
    
  end
    
  

  it "should link to the right page" do
    params = HashWithIndifferentAccess.new(:controller => "projects", :action => "index")
    view = TestView.new
    view.controller = ProjectsController
    view.header_and_title
  end
  
  
  it "should correctly colour the text" do
    path = "#{RAILS_ROOT}/spec/fixtures/colour/sample_stdout.html"
    File.open(path, "w+") do |f|
      f.write "<link rel='stylesheet' href='style.css'>"
      f.write "This test in #{__FILE__}:#{__LINE__} is passing if the text below is coloured and looks good :P"
      f.write "<pre>"
      f.write color_format(File.read("#{RAILS_ROOT}/spec/fixtures/colour/sample_stdout"))
      f.write "</pre>"
    end
    `open #{path}`
  end
end
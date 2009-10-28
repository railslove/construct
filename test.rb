require 'rubygems'
require 'popen4'

status = POpen4::popen4('do_the_impossible') do |stdout, stderr, stdin, pid|
  p stdout.read
  p stderr.read
end

p status
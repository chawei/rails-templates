##
# Project: App_template
# Author: Paul Kruger
# Email: paul@miamiphp.org
# Company: Speeduneed.com
# Date Created: April 23 2009
#This file is for your general github setting and default choices
##
def load_template_b(template)
  begin
    code = open(template).read
    in_root { self.eval(code) }
  rescue LoadError
    raise "The template [#{template}] could not be loaded."
  rescue LoadError, Errno::ENOENT => e
    raise "The template [#{template}] could not be loaded. Error: #{e}"
  end
end

nickname = 'miamiphp'

github_url = "http://github.com/#{nickname}/rails-templates/raw/master/"

if File.exists?("../config.rb")
  load '../config.rb'
else 
  config = github_url + "config.rb"
  load_template_b config
end

puts full_name

#loading template options
#templates_url = github_url + "templates.rb"
#load_template templates_url


#templates.inspect

#templates.each { |template|
#  puts template.name + "\n" 
#} 

#loading optional templates
#templates_url = github_url + "optional.rb"
#load_template templates_url

##
# Project: App_template
# Author: Paul Kruger
# Email: paul@miamiphp.org
# Company: Speeduneed.com
# Date Created: April 23 2009
#This file is for your general github setting and default choices
##

nickname = 'miamiphp'

github_url = "http://github.com/#{nickname}/rails-templates/raw/master/"

if File.exists?("../config.rb")
  load '../config.rb'
else 
  config = github_url + "config.rb"
  code = open(config).read
  puts code
  eval(open(config).read)
puts "1:" +full_name
end
puts "2:" +full_name

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

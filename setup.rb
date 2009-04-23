##
# Project: App_template
# Author: Paul Kruger
# Email: paul@miamiphp.org
# Company: Speeduneed.com
# Date Created: April 23 2009
#This file is for your general github setting and default choices
##

nickname = 'miamiphp'

github_url = "http://github.com/#{github_nick}/rails-templates/raw/master/"

if File.exists?("../config.rb") then
  load '../config.rb'
else 
  config = github_url + "config.rb"
  load_template config
end


#load_template "http://github.com/grillpanda/rails-templates/raw/master/base.rb"
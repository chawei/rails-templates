run "echo Speeduneed Inc > README"

run 'git config --global user.name "Paul Kruger"'
run 'git config --global user.email paul@miamiphp.org'

# Delete unnecessary files
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"

run "cp config/database.yml config/example_database.yml"

#Setup Git
git :init

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

#Download JQuery
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js > public/javascripts/jquery.js"
run "curl -L http://jqueryjs.googlecode.com/svn/trunk/plugins/form/jquery.form.js > public/javascripts/jquery.form.js"


# Install submoduled plugins
  plugin 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :submodule => true
  plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git', :submodule => true
  plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git', :submodule => true
  plugin 'exception_notifier', :git => 'git://github.com/rails/exception_notification.git', :submodule => true
  plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git', :submodule => true
  plugin 'factory_girl', :git => 'git://github.com/thoughtbot/factory_girl.git', :submodule => true
  plugin 'shoulda', :git => 'git://github.com/thoughtbot/shoulda.git', :submodule => true
  plugin 'quietbacktrace', :git => 'git://github.com/thoughtbot/quietbacktrace.git', :submodule => true
  plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git', :submodule => true
  plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git', :submodule => true
  plugin 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git', :submodule => true
  # plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git', :submodule => true
  plugin 'acts_as_taggable_redux', :svn => 'http://svn.devjavu.com/geemus/rails/plugins/acts_as_taggable_redux', :submodule => true
  plugin 'aasm', :git => 'git://github.com/rubyist/aasm.git', :submodule => true
  plugin 'cucumber', :git => 'git://github.com/aslakhellesoy/cucumber.git', :submodule => true 
  plugin 'redgreen', :git => 'git://github.com/JackDanger/jspec_red_green.git', :submodule => true 
 
  gem 'ruby-openid', :lib => 'openid'
  gem 'sqlite3-ruby', :lib => 'sqlite3'
  gem 'hpricot', :source => 'http://code.whytheluckystiff.net'
  gem 'RedCloth', :lib => 'redcloth'


  # Initialize submodules
  git :submodule => "init"
  rake('gems:install', :sudo => true)

 
# Set up sessions, RSpec, user model, OpenID, etc, and run migrations
  rake('db:sessions:create')
  generate("authenticated", "user session")
  generate("roles", "Role User")
  generate("rspec")
  rake('acts_as_taggable_redux:db:create')
  rake('open_id_authentication:db:create')
  rake('db:migrate')
 
# Set up session store initializer
  initializer 'session_store.rb', <<-END
ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
ActionController::Base.session_store = :active_record_store
END



#doing initial commit
git :add => ".", :commit => "-m 'initial commit'"

generate :controller, "dashboard index"
route "map.root :controller => 'dashboard'"
git :add => ".", :commit => "-m 'adding dashboard controller'"




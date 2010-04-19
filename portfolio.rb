test_gem  = ask("How will you test?\n\n[1] Shoulda\n[2] Rspec")
jquery    = yes?('Replace prototype/scriptaculous with jQuery?')
db_prefix = ask("What’s your db prefix? (eg. \#{db_prefix}_development)")
db_prefix = 'app' if db_prefix.blank?

# gems
gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'

# the gem command currently doesn't support specific environments
# so we have to edit config/environments/test.rb directly
file 'config/environments/test.rb', <<-END
#{File.read('config/environments/test.rb')}
config.gem 'cucumber', :lib => false, :version => '>= 0.2.2'
config.gem 'webrat', :lib => false, :version => '>= 0.4.3'
config.gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :version => '>= 1.2.0', :source => 'http://gems.github.com'
#{if test_gem == '1' then "config.gem 'thoughtbot-shoulda', :lib => 'shoulda', :version => '>= 2.10.1', :source => 'http://gems.github.com'" elsif test_gem == '2' then "config.gem 'rspec', :lib => false, :version => '>= 1.2.0'\nconfig.gem 'rspec-rails', :lib => false, :version => '>= 1.2.0'" end}
END

rake('gems:install', :sudo => true)


# generators
generate('cucumber')
generate('rspec') if test_gem == '2'

# generate a database.yml.example that uses mysql
# and replace database.yml with it also
file 'config/database.yml.example', <<-END
development:
  adapter: mysql
  encoding: utf8
  host: localhost
  user: root
  password:
  database: #{db_prefix}_development

test:
  adapter: mysql
  encoding: utf8
  host: localhost
  user: root
  password:
  database: #{db_prefix}_test

# production:
#   adapter: mysql
#   encoding: utf8
#   host: localhost
#   user: root
#   password:
#   database: #{db_prefix}_production
END
run 'cp config/database.yml.example config/database.yml'
rake 'db:create:all'

# Install Authentication Plugins
use_auth  = ask("Install User Authentication?(Yes)\n\n[1] Yes\n[2] No")
use_auth = '1' if use_auth.blank?

if use_auth == '1'
  use_auth_type  = ask("Which Authentication?(Restful)\n\n[1] Restful\n[2] Authlogic")
  use_auth_type = '1' if use_auth_type.blank?

  if use_auth_type == '1' then
    plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git', :submodule => true
  else 
    gem 'authlogic', :lib => 'authlogic', :source => 'http://gems.github.com'
  end

  use_openid  = ask("Install OpenId?(No)\n\n[1] Yes\n[2] No")
  use_openid = '2' if use_openid.blank?

  if use_openid == '1' then
    gem 'ruby-openid', :lib => 'openid'
    plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git', :submodule => true
  end

  use_role_requirement  = ask("Install Role Requirement?(No)\n\n[1] Yes\n[2] No")
  use_role_requirement = '2' if use_role_requirement.blank?

  if use_role_requirement == '1' then
    plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git', :submodule => true
  end

end

# Install Paperclip
paperclip  = ask("Install Paperclip?(Yes)\n\n[1] Yes\n[2] No")
paperclip = '1' if paperclip.blank?
if paperclip == '1' then
  plugin 'paperclip', :git => 'git://github.com/thoughtbot/paperclip.git', :submodule => true
end

# jQuery
if jquery
  run 'rm -f public/javascripts/*'
  run 'curl -L http://code.jquery.com/jquery-1.4.min.js > public/javascripts/jquery.js'
end


# Delete unnecessary files
run "rm -rf ./app/views/layouts/*"
run "rm public/index.html"
run "rm public/robots.txt"
run "rm public/images/rails.png"
# run "rm public/favicon.ico"


# Set up git repository for this project
# Ignore the usual stuff and make the first commit
git :init

file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
END

run 'touch tmp/.gitignore log/.gitignore vendor/.gitignore'

git :add => '.'
git :commit => "-m 'initial commit'"

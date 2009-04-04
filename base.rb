gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
gem 'RedCloth', :lib => 'redcloth'

# the gem command currently doesn't support specific environments
# so we have to edit config/environments/test.rb directly

test_gem = ask("How will you test?\n\n[1] Shoulda\n[2] Rspec")

file 'config/environments/test.rb', <<-END
#{File.read('config/environments/test.rb')}
config.gem 'cucumber', :lib => false, :version => '>= 0.2.2'
config.gem 'webrat', :lib => false, :version => '>= 0.4.3'
#{if test_gem == '1' then "config.gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'" elsif test_gem == '2' then "config.gem 'rspec', :lib => false, :version => '>= 1.2.0'\nconfig.gem 'rspec-rails', :lib => false, :version => '>= 1.2.0'" end}
END

rake('gems:install', :sudo => true)


# generate a database.yml.example that uses mysql
# and replace database.yml with it also
file 'config/database.yml.example', <<-END
development:
  adapter: mysql
  encoding: utf8
  host: localhost
  user: root
  password:
  database: app_development

test:
  adapter: mysql
  encoding: utf8
  host: localhost
  user: root
  password:
  database: app_test

production:
  adapter: mysql
  encoding: utf8
  host: localhost
  user: root
  password:
  database: app_production
END
run 'cp config/database.yml.example config/database.yml'


# set up git repository for this project
# ignore the usual stuff and make the first commit
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

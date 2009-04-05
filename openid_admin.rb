load_template "http://github.com/grillpanda/rails-templates/raw/master/base.rb"

gem 'ruby-openid', :lib => 'openid'
rake('gems:install', :sudo => true)

plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git', :submodule => true

git :submodule => 'init'

rake 'open_id_authentication:db:create'
rake 'db:migrate'

git :add => '.'
git :commit => "-m 'adding open_id_authentication'"

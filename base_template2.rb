#Setting Time and Date
day, month, year = Time.now.day, Time.now.month, Time.now.year

#Adding Author and Company Info
project  = ask("What is the title of the project?(My Project) >")
project = 'My Project' if project.blank?

email  = ask("Authors Email Address?(user@gmail.com) >")
email = 'user@gmail.com' if email.blank?

full_name = ask("What is the authors full name?(Anonymous) >")
full_name = 'Anonymous' if full_name.blank?

company = ask("What is your authors company name?(Company Name) >")
company = 'Company Name' if company.blank?

company_url = ask("What is your authors company url?(http://yourdomain.com) >")
company_url = 'http://yourdomain.com' if company_url.blank?

file "README", <<-END
##
# Project: #{project}
# Author: #{full_name}
# Email: #{email}
# Company: #{company}
# Date Created: #{month}/#{day}/#{year}
##
END


#End Adding Company Info


run 'script/generate scaffold article title:string body:text alias:string'

file "test/fixtures/articles.yml", <<-END
one:
  id: 1
  title: Home Page
  body: Our Home Page
  alias: 

two:
  id: 2
  title: About Us
  body: About Us
  alias: about

three:
  id: 3
  title: Privacy Policy
  body: Content of Privacy Policy
  alias: privacy

END

file "app/controllers/articles_controller.rb", <<-END
class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    if params[:id].to_i.to_s === params[:id]
      @article = Article.find(params[:id])
    else
      @article = Article.find_by_alias(params[:id])
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
end
END
rake 'db:migrate'
rake 'db:fixtures:load'
file "app/views/articles/show.html.erb", <<-END
<h1><%=h @article.title %></h1>
<p>
  <%=h @article.body %>
</p>
END
file "app/views/articles/index.html.erb", <<-END
<% @articles.each do |article| %>
    <%= link_to article.title, article %><br />
<% end %>
END
=begin
file "lib/tasks/appinit.rake", <<-END
desc "Load default data into database"
task :appinit do
   require 'active_record/fixtures'
   ActiveRecord::Base.establish_connection(
       ActiveRecord::Base.configurations["development"])
   Fixtures.create_fixtures("test/fixtures",
       ActiveRecord::Base.configurations[:fixtures_load_order])
end
END
=end

rake 'db:migrate'
#backing up db settings
run 'cp config/database.yml config/database.yml.example'

#Download JQuery
run 'curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js'
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js > public/javascripts/jquery-1.2.6.min.js"
run "curl -L http://jqueryjs.googlecode.com/svn/trunk/plugins/form/jquery.form.js > public/javascripts/jquery.form.js"


# Install plugins
gem 'haml', :lib => 'haml'
gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
gem 'hpricot', :source => 'http://code.whytheluckystiff.net'
gem 'RedCloth', :lib => 'redcloth'

#Setup Git
git :init

run 'git config --global user.name "' + full_name +'"'
run 'git config --global user.email "' + email +'"'

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

generate :controller, "dashboard index show"

# Delete unnecessary files
run "rm -rf ./app/views/layouts/*"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm public/images/rails.png"
# End Delete unnecessary files

file "public/stylesheets/application.css", <<-END
body{
background:lightblue;
text-align:center;
margin:0px;
padding:0px;
}
#wrapper{
width:750px;
background:white;
border:1px solid black;
margin-top:20px;
text-align:left;
margin-left:auto;
margin-right:auto;
padding:20px;
}
#navigation{
width:300px;
float:right;
text-align:right;
}
#navigation a{
color:black;
text-decoration:none;
}
#footer{
text-align:center;
}
#footer a{
color:black;
text-decoration:none;
}
END

file "app/views/layouts/_navigation.rhtml", <<-END
<div id="navigation">
	<%= link_to "Home", :controller => "/" %> | 	
  <%= link_to "Articles", :controller => "articles" %> |
  <%= link_to "Login", :controller => "/users/login" %> | 
  <%= link_to_unless_current("About Us", { :action => "about" }) %>
</div>
END

file "app/views/layouts/_footer.rhtml", <<-END
<div id="footer">
  <%= link_to "Home", :controller => "/" %> | 	
  <%= link_to "Articles", :controller => "articles" %> | 	
  <%= link_to "Exceptions", :controller => "/logged_exceptions" %> | 
  <%= link_to_unless_current("About Us", { :action => "about" }) %> | 
  <%= link_to_unless_current("Privacy", { :action => "privacy" }) %>
</div>
END

file "app/views/layouts/application.html.haml", <<-END
!!! Strict
%html
  %head
    %title | #{project}
    = stylesheet_link_tag("application")
  %body
    #wrapper
      #header
        = render :partial => 'layouts/navigation'
      #content
        = yield
      #footer
        = render :partial => 'layouts/footer'
END

file "app/views/articles/home.rhtml", <<-END
<h1>Welcome to #{project}</h1>
<p>This project was created by #{full_name}</p>
END

#end pages



#Installing Authentication Plugins
use_auth  = ask("Install User Authentication?(Yes)\n\n[1] Yes\n[2] No")
use_auth = '1' if use_auth.blank?

if use_auth == '1'
  use_auth_type  = ask("Which Authentication?(Authlogic)\n\n[1] Authlogic\n[2] Restful")
  use_auth_type = '1' if use_auth_type.blank?

  if use_auth_type == '2' then
    plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git', :submodule => true
  else 
    gem 'authlogic', :lib => 'authlogic', :source => 'http://gems.github.com'
    run 'script/generate session user_session'
    run 'script/generate model user'

    route 'map.resource :account, :controller => "users"'
    route 'map.resources :users'
    route 'map.resource :user_session'
    route 'map.root :controller => "user_sessions", :action => "new"'
    time_real = time.real
file "db/migrate/@{time_real}_create_users.rb", <<-END
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.timestamps
      t.string :login, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.integer :login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
    end

    add_index :users, :login
    add_index :users, :persistence_token
    add_index :users, :last_request_at
  end

  def self.down
    drop_table :users
  end
end
END
file "app/models/user.rb", <<-END
class User < ActiveRecord::Base
  acts_as_authentic
   #acts_as_authentic do |c|
   #   c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
   #end # block optional
 end
END
file "app/models/user_sessions_controller.rb", <<-END
class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
END
file "app/views/user_sessions/new.html.erb", <<-END
<h1>Login</h1>
<% form_for @user_session, :url => user_session_path do |f| %>
  <%= f.error_messages %>
  <%= f.label :login %><br />
  <%= f.text_field :login %><br />
  <br />
  <%= f.label :password %><br />
  <%= f.password_field :password %><br />
  <br />
  <%= f.check_box :remember_me %><%= f.label :remember_me %><br />
  <br />
  <%= f.submit "Login" %>
<% end %>
END

file "app/controllers/application_controller.rb", <<-END
class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
END

file "app/controller/users_controller.rb", <<-END
class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
END
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

#End Authentication Setup



#setup routes
#route 'map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"'
route "map.root :controller => 'articles', :action => 'show', :id => '1'"
route "map.resources :controller => 'dashboard'"
route "map.resources :controller => 'articles'"

#route 'map.root :controller => "user_sessions", :action => "new"' #options login as default route

#end routes

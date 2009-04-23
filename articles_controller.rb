run 'script/generate scaffold article title:string body:text alias:string registered:boolean'

file "test/fixtures/articles.yml", <<-END
one:
  id: 1
  title: Home Page
  body: Our Home Page
  alias: home
  registered: false

two:
  id: 2
  title: About Us
  body: About Us
  alias: about
  registered: false

three:
  id: 3
  title: Privacy Policy
  body: Content of Privacy Policy
  alias: privacy
  registered: false

four:
  id: 4
  title: Registered Users Content
  body: Content of Registered Content Page
  alias: registered
  registered: true

END

file "app/controllers/articles_controller.rb", <<-END
class ArticlesController < ApplicationController
  before_filter :require_user, :only => [:create, :new, :edit, :update]

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
  # GET /articles/1.xml
  def show
    if params[:id].to_i.to_s === params[:id]
      @article = Article.find(params[:id])
    else
      @article = Article.find_by_alias(params[:id])
    end
    
    if @article.registered == true
      if !defined? @current_user.login
        flash[:notice] = "Please login to view this Article!"
        redirect_to :action =>'index'
        return
      end
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
    <% if article.alias != 'home' %>
      <% if article.registered == false || defined? @current_user.login %>
        <%= link_to article.title, 'articles/'+article.alias %><br />
      <% end %>
    <% end %>
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

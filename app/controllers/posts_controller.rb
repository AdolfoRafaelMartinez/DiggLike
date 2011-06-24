class PostsController < ApplicationController 
  layout "posts"
  def index 
    @posts = Post.find(:all, :order => "created_at DESC") 
    respond_to do |format| 
      format.html # index.html.erb 
      format.xml  { render :xml => @posts } 
    end 
  end 
  def parked 
    @posts = Post.find(:all, :conditions => ["length(response)=0"], :order => "created_at DESC") 
  end 
  def thumbs 
    if params[:period] == "Recent" then 
      @posts = Post.find(:all, :conditions => ["length(response)!=0"], :order => "created_at DESC") 
    else 
      t1 = Time.now
      if params[:period] == "24" 
        t0 = (t1 - 1 * 24 * 60 * 60).strftime('%Y-%m-%d %H:%M:%S')
      elsif params[:period] == "7" 
        t0 = (t1 - 7 * 24 * 60 * 60).strftime('%Y-%m-%d %H:%M:%S')
      elsif params[:period] == "30" 
        t0 = (t1 - 30 * 24 * 60 * 60).strftime('%Y-%m-%d %H:%M:%S')
      elsif params[:period] == "365" 
        t0 = (t1 - 365 * 24 * 60 * 60).strftime('%Y-%m-%d %H:%M:%S')
      end 
      @posts = Post.find(:all, :conditions => ["created_at > ? AND length(response)!=0", t0], :order => "rate DESC") 
    end
  end 
  def rateup 
    @post = Post.find(params[:id]) 
    @post.rate = @post.rate + 1 
    @post.save 
    if params[:period] == nil then
      redirect_to :action => 'parked'
    else
      redirect_to :action => 'thumbs', :period => params[:period]
    end
  end 
  def ratedn 
    @post = Post.find(params[:id]) 
    @post.rate = @post.rate - 1 
    @post.save 
    if params[:period] == nil then
      redirect_to :action => 'parked'
    else
      redirect_to :action => 'thumbs', :period => params[:period]
    end
  end 
  def edit 
    @post = Post.find(params[:id]) 
  end 
  def show 
    @post = Post.find(params[:id]) 
    respond_to do |format| 
      format.html # show.html.erb 
      format.xml  { render :xml => @post } 
    end 
  end 
  def new
    @post = Post.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end
  def create
    @post = Post.new(params[:post])
    @post.rate = 0
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end

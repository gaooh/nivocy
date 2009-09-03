require 'rss/maker'
#
# アイデア管理
#
class IdeasController < ApplicationController
  before_filter :signin_filter
  after_filter :to_rss_filter, :only=> [ :rss ]
  
  def index
    @idea_pages, @ideas = paginate(:idea, :per_page => 10, :order_by => "updated_at desc")
    @idea_categories = IdeaCategory.find(:all)
    @recent_ideas = Idea.find_recent_comment_ideas(5)
  end
  
  def rss
    ideas = Idea.find(:all, :order => "updated_at desc", :limit => 20)

    rss = RSS::Maker.make("1.0") do |maker|
      maker.channel.about = url_for(:controller => :idea, :action => 'rss')
      maker.channel.title = APP_CONFIG[:domain]
      maker.channel.link = url_for(:controller => :idea, :action => 'index')
      maker.channel.description = "nivocy"
      maker.channel.copyright = "Copyright(c) 2007 GAOOH All Rights Reserved."

      ideas.each_with_index do |idea,index|
        item = maker.items.new_item
        item.title = idea.title
        item.description = idea.body
        item.date = idea.created_at
        item.link = "#{APP_CONFIG[:url]}/ideas/show/#{idea.id}"
      end

      maker.items.do_sort = true
      maker.items.max_size = 20
    end
    render :text => rss.to_s, :layout => false
  end
  
  def search
    index 
    @search = Forms::IdeaSearch.new(params[:search])
    
    @idea_pages = Paginator.new self, Idea.count_ideas_by_word(@search.word, @search.idea_category_id), 10, @params['page']
    @ideas = Idea.find_ideas_by_word(@search.word, @search.idea_category_id, @idea_pages.items_per_page, @idea_pages.current.offset)
    
    render :action => 'index'
  end
  
  def new
    @idea_categories = IdeaCategory.find(:all)
    @idea_attachments = IdeaAttachment.find_my_attachment(_user_id)
  end
  
  def create
    idea = Idea.new(params[:idea])
    params[:idea][:body].gsub!(/<p>/,"");
    params[:idea][:body].gsub!(/<\/p>/,"");
    params[:idea][:body].gsub!(/<div.*?>/,"");
    params[:idea][:body].gsub!(/<\/div>/,"");
    params[:idea][:body].gsub!(/src="..\//,"src=\"/");
    params[:idea][:body].gsub!(/href="..\//,"href=\"/");
    
    idea.user_id = _user_id
    if idea.save
      flash[:notice] = '新規アイデアを投稿しました。'
      redirect_to :action => 'index'
    else
      flash[:warning] = 'アイデアの投稿ができませんでした。'
      @idea_categories = IdeaCategory.find(:all)
      @idea_attachments = IdeaAttachment.find_my_attachment(_user_id)
      render :action => 'new'
    end
  end
  
  def show
    @idea = Idea.find(params[:id])
    @grade_memeber_count = IdeaGrade.count(:select => 'distinct(user_id)', :conditions => ['idea_id = ?', params[:id]])
    @grade_types = GradeType.find(:all)
    @idea_comment_types = IdeaCommentType.find(:all)
    @comments = IdeaComment.find(:all, :conditions => ['idea_id = ? ', params[:id]])
  end
  
  def ajax_add_comment
    @comment = IdeaComment.new(params[:idea_comment])
    @comment.user_id = _user_id
    @comment.save
    
    @index = IdeaComment.count(:conditions => ['idea_id = ? ', params[:id]]) + 1
  end
  
  def ajax_show_type_comment
    @comments = IdeaComment.find(:all, :conditions => ['idea_id = ? and idea_comment_type_id = ? ', 
                                                       params[:idea_id], params[:idea_comment_type_id]])
  end
  
  def spider_graph
    idea = Idea.find(params[:id])
    g = Gruff::Spider.new(5, params[:size])
    g.title = ' '

    averages = IdeaGrade.average(:value, :conditions => [' idea_id = ?', idea.id], :group => 'grade_type_id')
    averages.each {|average|
      idea_grade_type = GradeType.find(average[0])
      g.data(idea_grade_type.name, [average[1]])
    }
    g.font = GRUFF_CONFIG[:ja_font]
    send_data(g.to_blob, :type => 'image/png')
  end
  
  def stocked_graph
    idea = Idea.find(params[:id])
    g = Gruff::Bar.new(params[:size])
    g.title = ' '
    
    @grade_types = GradeType.find(:all)
    @grade_types.each do |grade_type|
      g.labels[grade_type.id] = grade_type.name
    end
    
    sums = IdeaGrade.sum(:value, :conditions => [' idea_id = ?', idea.id], :group => 'grade_type_id')
    sums.each do |sum|
      idea_grade_type = GradeType.find(sum[0])
      g.data(idea_grade_type.name, [sum[1]])
    end
    g.font = GRUFF_CONFIG[:ja_font]
    g.minimum_value = 0
    send_data(g.to_blob, :type => 'image/png')
  end
  
  def grade
    idea_id = params[:idea][:id]
    h_grade = params[:grade]
    h_grade.each_pair do |key, value|
      idea_grade = IdeaGrade.find(:first, :conditions => ['idea_id = ? and user_id = ? and grade_type_id = ? ', idea_id, _user_id, key])
      if idea_grade.nil?
        idea_grade = IdeaGrade.new({:idea_id => idea_id, :user_id => _user_id, :grade_type_id => key, :value => value})
        idea_grade.save
      else
        idea_grade.value = value
        idea_grade.save
      end
    end
    flash[:notice] = '評価を受け付けました。'
    redirect_to :action => 'show', :id => idea_id
  end
  
  def grade_detail
    @idea = Idea.find(params[:id])
    @grade_memeber_count = IdeaGrade.count(:select => 'distinct(user_id)', :conditions => ['idea_id = ?', params[:id]])
    @grade_types = GradeType.find(:all)
    
    @idea_grade_users = IdeaGrade.find(:all, :conditions => [' idea_id = ?', params[:id]], :group => 'user_id')
    @h_idea_grade = Hash.new
    @idea_grade_users.each do |idea_grade_user|
      @h_idea_grade[idea_grade_user.user_id] = IdeaGrade.find(:all, 
                                                              :conditions => ['idea_id = ? and user_id = ?',
                                                                              params[:id], idea_grade_user.user_id])
    end
    
  end
  
  def edit
    @idea = Idea.find(params[:id])
    @idea_categories = IdeaCategory.find(:all)
    @idea_attachments = IdeaAttachment.find_my_attachment( _user_id)
  end
  
  def update
    idea = Idea.find(params[:idea][:id])
    params[:idea][:body].gsub!(/<p>/,"");
    params[:idea][:body].gsub!(/<\/p>/,"");
    params[:idea][:body].gsub!(/<div.*?>/,"");
    params[:idea][:body].gsub!(/<\/div>/,"");
    params[:idea][:body].gsub!(/src="..\//,"src=\"/");
    params[:idea][:body].gsub!(/href="..\//,"href=\"/");
  
    if idea.update_attributes(params[:idea])
      flash[:notice] = 'アイデアを修正しました。'
      redirect_to :action => 'show', :id => idea.id
    else
      flash[:warning] = 'アイデアを修正に失敗しました。'
      redirect_to :action => 'show', :id => idea.id
    end
  end
  
  def destroy
    @idea = Idea.find(params[:idea][:id])
    if @idea.destroy
      flash[:notice] = "アイデア「#{@idea.title}」を削除しました。"
      redirect_to :controller => :ideas
    else
      flash[:notice] = "アイデアの削除に失敗しました。"
      redirect_to :action => 'show', :id => @idea.id
    end
  end
end

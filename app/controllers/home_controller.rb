require 'rss/maker'

class HomeController < ApplicationController
  
  before_filter :signin_filter
  after_filter :to_rss_filter, :only=> [ :rss ]

  verify :redirect_to => { :action => :index }
         
  def index
    @tasks = Task.find_my_tasks(_user_id)
    @task_count = Task.count_my_tasks(_user_id)
    
    @schedules = Schedule.findTodayByUserId(_user_id)
    @meetings = Meeting.find_entry_meeting(_user_id)
    
    @projects = Project.find_all_by_user_id(_user_id)
    @users = User.find(:all)
    
    @ideas = Idea.find_my_ideas(_user_id, 5, 0)
  end
  
  def rss
   tasks = Task.find_my_tasks(_user_id, 20)
     
   rss = RSS::Maker.make("1.0") do |maker|
     maker.channel.about = url_for(:controller => _user_name, :action => 'rss')
     maker.channel.title = APP_CONFIG[:domain]
     maker.channel.link = url_for(:controller => 'home', :action => 'index')
     maker.channel.description = "nivocy"
     maker.channel.copyright = "Copyright(c) 2007 GAOOH All Rights Reserved."

     tasks.each_with_index do |task,index|
       item = maker.items.new_item
       item.title = task.title
       item.description = task.content
       item.date = task.created_at
       item.link = "#{APP_CONFIG[:url]}/tasks/show/#{task.id}"
     end

     maker.items.do_sort = true
     maker.items.max_size = 20
   end
   render :text => rss.to_s, :layout => false
  end
end

class MilestonesController < ApplicationController
  
  def list
    @project = Project.find(params[:project_id])
    @milestones = Milestone.find_all_by_project_id(@project.id)
  end
  
  def edit
    @milestone = Milestone.find(params[:id])
  end
  
  def update
    milestone = Milestone.find(params[:id])
    milestone.goal_at = Util.parse_by_day_time(params[:milestone_goal_at])
    if milestone.update_attributes(params[:milestone])
      flash[:notice] = "#{milestone.name}を更新しました。"
      redirect_to :action => 'list', :project_id => milestone.project_id
    else
      flash[:error] = "マイルストーンの更新に失敗しました。"
      redirect_to :action => 'edit', :project_id => milestone.id
    end
  end
  
  def new
    @project = Project.find(params[:project_id])
    @milestone = Milestone.new
    @milestone.project_id = @project.id
  end
  
  def create
    milestone = Milestone.new(params[:milestone])
    milestone.goal_at = Util.parse_by_day_time(params[:milestone_goal_at])
    milestone.position = Milestone.find_next_position(params[:milestone][:project_id])
    if milestone.save
      flash[:notice] = "#{milestone.name}を追加しました。"
      redirect_to :action => 'list', :project_id => milestone.project_id
    else
      flash[:error] = "マイルストーンの追加に失敗しました。"
      redirect_to :action => 'new', :project_id => milestone.project_id
    end
  end
  
  def sort
    params[:milestones].each_with_index do | milestone, index |
      sort_milestone = Milestone.find(milestone)
      sort_milestone.position = index + 1
      sort_milestone.save
    end
    render :nothing => true
  end
  
  def ajax_destory
    @milestone = Milestone.find(params[:id])
    @milestone.delete_at = Time.now
    @milestone.save
  end
end

# == Schema Information
# Schema version: 49
#
# Table name: tasks
#
#  id             :integer(11)     not null, primary key
#  project_id     :integer(11)     not null
#  milestone_id   :integer(11)     
#  create_user_id :integer(11)     not null
#  treat_user_id  :integer(11)     not null
#  status_id      :integer(11)     not null
#  title          :string(200)     default(""), not null
#  content        :string(4000)    default(""), not null
#  created_at     :datetime        
#  goal_at        :datetime        not null
#  complete_at    :datetime        
#  updated_at     :datetime        not null
#  deleted_at     :datetime        
#

class Task < ActiveRecord::Base
  acts_as_paranoid
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :project
  belongs_to :status
  belongs_to :milestone
  belongs_to :create_user, :foreign_key=>"create_user_id", :class_name=>"User"
  belongs_to :treat_user, :foreign_key=>"treat_user_id", :class_name=>"User"
  has_many :task_logs
  
  # 未完了の自分のタスク一覧を取得する
  def self.find_my_tasks(user_id, limit=5)
    find(:all, :conditions=>[" treat_user_id = ? and complete_at is null ", user_id], :limit=> limit)
  end
  
  # 未完了の自分のタスク一覧数を取得する
  def self.count_my_tasks(user_id)
    count(:conditions=>[" treat_user_id = ? and complete_at is null ", user_id])
  end
  
  # task　が完了ステータスであるか
  def completion?
    self.status_id == Status::COMPLETION ? true : false
  end
end

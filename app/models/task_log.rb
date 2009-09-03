# == Schema Information
# Schema version: 49
#
# Table name: task_logs
#
#  id             :integer(11)     not null, primary key
#  task_id        :integer(11)     not null
#  change_user_id :integer(11)     not null
#  message        :string(4000)    default(""), not null
#  created_at     :datetime        
#  updated_at     :datetime        not null
#  deleted_at     :datetime        
#

class TaskLog < ActiveRecord::Base
  acts_as_paranoid
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :user, :foreign_key=>"change_user_id", :class_name=>"User"
  
  # 未完了の自分のタスク一覧を取得する
  def self.count_task_log(task_id)
    count(:conditions=>[" task_id = ? ", task_id])
  end
  
end

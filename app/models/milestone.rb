# == Schema Information
# Schema version: 49
#
# Table name: milestones
#
#  id          :integer(11)     not null, primary key
#  name        :string(200)     default(""), not null
#  position    :integer(11)     not null
#  project_id  :integer(11)     not null
#  description :string(500)     
#  goal_at     :datetime        not null
#  deleted_at  :datetime        
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Milestone < ActiveRecord::Base
  acts_as_paranoid
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :project
  
  # プロジェクト別のマイルストーン一覧をpositionでソートし返す
  def self.find_all_by_project_id(project_id)
    find(:all, :conditions=>[' project_id = ? ', project_id], :order => 'position')
  end
  
  #　新規作成時のpositionを取得
  def self.find_next_position(project_id)
    milestone_count = count(:conditions=>[' project_id = ? ', project_id])
    return milestone_count+1
  end
end

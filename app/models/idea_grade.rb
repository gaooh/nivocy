# == Schema Information
# Schema version: 49
#
# Table name: idea_grades
#
#  id            :integer(11)     not null, primary key
#  idea_id       :integer(11)     not null
#  user_id       :integer(11)     not null
#  grade_type_id :integer(11)     not null
#  value         :integer(11)     not null
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  deleted_at    :datetime        
#

class IdeaGrade < ActiveRecord::Base
  acts_as_paranoid
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :idea
  belongs_to :grade_type
  belongs_to :user
  
end

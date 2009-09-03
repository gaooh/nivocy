# == Schema Information
# Schema version: 49
#
# Table name: idea_comments
#
#  id                   :integer(11)     not null, primary key
#  idea_id              :integer(11)     not null
#  user_id              :integer(11)     not null
#  comment              :text            default(""), not null
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  deleted_at           :datetime        
#  idea_comment_type_id :integer(11)     not null
#

class IdeaComment < ActiveRecord::Base
  acts_as_paranoid
  
  # --------------------------
  # validatie
  # --------------------------
  validates_presence_of :idea_id, :user_id, :comment
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :idea
  belongs_to :user
  
  def self.find_recent_comment_idea_ids(limit)
    find(:all, :select => "distinct(idea_id)", :order => 'updated_at desc', :limit => limit)
  end
  
end

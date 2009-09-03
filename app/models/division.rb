# == Schema Information
# Schema version: 49
#
# Table name: divisions
#
#  id         :integer(11)     not null, primary key
#  name       :string(200)     default(""), not null
#  parent_id  :integer(11)     
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class Division < ActiveRecord::Base
  acts_as_tree :order=>'id'
  
  # --------------------------
  # relation
  # --------------------------
  has_many :users_divisions
  has_many :users, :through=> :users_divisions, :conditions => "users_divisions.deleted_at IS NULL"
  
end

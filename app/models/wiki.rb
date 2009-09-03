# == Schema Information
# Schema version: 49
#
# Table name: wikis
#
#  id             :integer(11)     not null, primary key
#  project_id     :integer(11)     not null
#  create_user_id :integer(11)     not null
#  title          :string(200)     default(""), not null
#  body           :string(4000)    default(""), not null
#  created_at     :datetime        
#  update_at      :datetime        not null
#  deleted_at     :datetime        
#

class Wiki < ActiveRecord::Base
end

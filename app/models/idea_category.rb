# == Schema Information
# Schema version: 49
#
# Table name: idea_categories
#
#  id         :integer(11)     not null, primary key
#  name       :string(200)     default(""), not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class IdeaCategory < ActiveRecord::Base
end

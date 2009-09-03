# == Schema Information
# Schema version: 47
#
# Table name: idea_images
#
#  id           :integer(11)     not null, primary key
#  idea_id      :integer(11)     not null
#  filename     :string(256)     default(""), not null
#  org_filename :string(256)     default(""), not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  deleted_at   :datetime        
#

class IdeaImage < ActiveRecord::Base
end

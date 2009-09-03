# == Schema Information
# Schema version: 49
#
# Table name: project_attachments
#
#  id           :integer(11)     not null, primary key
#  project_id   :integer(11)     not null
#  user_id      :integer(11)     not null
#  content_type :string(128)     default(""), not null
#  org_filename :string(200)     default(""), not null
#  size         :integer(11)     not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  deleted_at   :datetime        
#  file_data    :binary          
#  comment      :string(2000)    
#

class ProjectAttachment < ActiveRecord::Base
  
  IMAGE_CONTENT_TYPE_LIST = [ "image/png", "image/gif", "image/jpg" ]
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :project
  belongs_to :user
  
  # 画像ファイルかどうかを示す
  def image?
    IMAGE_CONTENT_TYPE_LIST.index(self.content_type) != nil ? true : false
  end
end

# == Schema Information
# Schema version: 49
#
# Table name: idea_attachements
#
#  id           :integer(11)     not null, primary key
#  idea_id      :integer(11)     not null
#  user_id      :integer(11)     not null
#  content_type :string(128)     default(""), not null
#  org_filename :string(200)     default(""), not null
#  size         :integer(11)     not null
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  deleted_at   :datetime        
#  file_data    :binary          
#

class IdeaAttachment < ActiveRecord::Base
  acts_as_paranoid
  
  IMAGE_CONTENT_TYPE_LIST = [ "image/png", "image/gif", "image/jpg", "image/jpeg" ]
  PDF_CONTENT_TYPE_LIST = [ "application/pdf" ]
  PPT_CONTENT_TYPE_LIST = [ "application/vnd.ms-powerpoint" ]
  EXCEL_CONTENT_TYPE_LIST = [ "application/vnd.ms-excel" ]
  WORD_CONTENT_TYPE_LIST = [ "application/msword"]
  ARCHIVE_CONTENT_TYPE_LIST = [ "application/x-compress", "application/x-zip-compressed", "application/zip",
                                "application/x-lha", "application/x-lha-compressed", "application/x-lk-rlestream"]
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :idea
  belongs_to :user
  
  def self.find_my_attachment(user_id)
    find(:all, :conditions => [' user_id = ? ', user_id], :order => ['updated_at desc'])
  end
  
  # 画像ファイルかどうかを示す
  def image?
    IMAGE_CONTENT_TYPE_LIST.index(self.content_type) != nil ? true : false
  end
  
  # PDFかどうかを返す
  def pdf?
    PDF_CONTENT_TYPE_LIST.index(self.content_type).nil? ? false : true
  end
  
  # PPTかどうかを返す
  def ppt?
    PPT_CONTENT_TYPE_LIST.index(self.content_type).nil? ? false : true
  end
  
  # Excelかどうか
  def excel?
    EXCEL_CONTENT_TYPE_LIST.index(self.content_type).nil? ? false : true
  end
  
  # Wordかどうか
  def doc?
    WORD_CONTENT_TYPE_LIST.index(self.content_type).nil? ? false : true
  end
  
  # 圧縮ファイルかどうか
  def archive?
    ARCHIVE_CONTENT_TYPE_LIST.index(self.content_type).nil? ? false : true
  end
end

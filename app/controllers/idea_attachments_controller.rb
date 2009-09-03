require 'RMagick'

#
# アイデア添付ファイル管理
#
class IdeaAttachmentsController < ApplicationController
  before_filter :signin_filter
  upload_status_for :upload, :status => :upload_status
  
  # ファイル一覧ページ
  def list
    @idea_attachment_pages, @idea_attachments = paginate(:idea_attachment, :per_page => 10, 
                                                         :conditions => [' user_id = ? ', _user_id], :order_by => "updated_at desc")
  end
  
  # 添付ファイルアップロード処理
  def upload
    
    begin
      case @request.method
        when :post
          @message = 'File uploaded: ' + params[:document][:file].size.to_s
          idea_attachment = IdeaAttachment.new(params[:idea_attachment])
          document = params[:document][:file]
        
          idea_attachment.content_type = document.content_type.chomp!
          idea_attachment.user_id = _user_id
          idea_attachment.org_filename = document.original_filename
          idea_attachment.size = document.size
          idea_attachment.file_data = document.read
          idea_attachment.save
    
          finish_upload_status "'#{@message}'"
      end
    rescue
      error($!)
      finish_upload_status "ファイルのアップロードに失敗しました。"
    end
  end
  
  # 添付ファイルを表示
  def view_file
    idea_attachment = IdeaAttachment.find(params[:id])
    send_data(idea_attachment.file_data, {:filename => idea_attachment.org_filename, :type => idea_attachment.content_type})
  end
  
  # サムネイルを作成する
  # 画像を縮小し、枠線をつけて傾ける
  def thumbnail
    idea_attachment = IdeaAttachment.find(params[:id])
    
    if idea_attachment.image?
      @headers['Content-Type'] = idea_attachment.content_type
      original = Magick::Image.from_blob(idea_attachment.file_data).first
      thumb = original.columns > 120 ? original.resize_to_fit(80,80) : original
      thumb = thumb.border(1, 1, 'white')
      thumb.background_color = "none"
      thumb.trim!
      
      render :text => thumb.to_blob, :layout => false
    elsif idea_attachment.pdf?
      render :file => "#{RAILS_ROOT}/public/images/file_icons/pdf.gif", :layout => false, :content_type => "image/gif"
    elsif idea_attachment.ppt?
      render :file => "#{RAILS_ROOT}/public/images/file_icons/ppt.gif", :layout => false, :content_type => "image/gif"
    elsif idea_attachment.excel?
      render :file => "#{RAILS_ROOT}/public/images/file_icons/xls.gif", :layout => false, :content_type => "image/gif"
    elsif idea_attachment.doc?
      render :file => "#{RAILS_ROOT}/public/images/file_icons/doc.gif", :layout => false, :content_type => "image/gif"
    elsif idea_attachment.archive?
      render :file => "#{RAILS_ROOT}/public/images/file_icons/archive.gif", :layout => false, :content_type => "image/gif"
    else
      render :text => "", :layout => false
    end
  end
  
  # ユーザのファイル一覧を更新する
  def ajax_update_user_list
    @idea_attachments = IdeaAttachment.find_my_attachment(_user_id)
  end
  
  def ajax_update_list
    @idea_attachment_pages, @idea_attachments = paginate(:idea_attachment, :per_page => 10, 
                                                         :conditions => [' user_id = ? ', _user_id], :order_by => "updated_at desc")
  end
  
  def upload_status
    render :inline => "<%= image_tag 'progress.gif', :size => '#{upload_progress.completed_percent rescue 0}x3' %> <%= upload_progress.completed_percent rescue 0 %>% complete", :layout => false
  end
  
  def destroy
    idea_attachment = IdeaAttachment.find(params[:idea_attachment][:id])
    idea_attachment.destroy
    redirect_to :action => :list
  end
end

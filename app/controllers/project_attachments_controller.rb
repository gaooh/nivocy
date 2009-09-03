require 'RMagick'

class ProjectAttachmentsController < ApplicationController
  before_filter :signin_filter
  upload_status_for :upload
  
  def list
    @project_attachment = ProjectAttachment.new(:project_id => params[:project_id])
    @project_attachment_pages, @project_attachments = paginate("project_attachments", :per_page => 10, :order_by => "id desc")
  end
  
  # 添付ファイルアップロード処理
  def upload
    
    begin
      case @request.method
        when :post
          @message = 'File uploaded: ' + params[:document][:file].size.to_s
          project_attachment = ProjectAttachment.new(params[:project_attachment])
          document = params[:document][:file]
        
          project_attachment.content_type = document.content_type.chomp!
          project_attachment.user_id = _user_id
          project_attachment.org_filename = document.original_filename
          project_attachment.size = document.size
          project_attachment.file_data = document.read
          project_attachment.save
        
          redirect_to :action => 'list', :project_id => project_attachment.project_id
    
          finish_upload_status "'#{@message}'"
      end
    rescue
      error($!)
      flash[:notice] = 'ファイルのアップロードに失敗しました。'
      redirect_to :action => 'list', :project_id => params[:project_attachment][:project_id]
    end
  end
  
  # 添付ファイルを表示
  def view_file
    project_attachment = ProjectAttachment.find(params[:id])
    send_data(project_attachment.file_data, {:filename => project_attachment.org_filename, :type => project_attachment.content_type})
  end
  
  # サムネイルを作成する
  # 画像を縮小し、枠線をつけて傾ける
  def thumbnail
    project_attachment = ProjectAttachment.find(params[:id])
    
    if project_attachment.image?
      @headers['Content-Type'] = project_attachment.content_type
      original = Magick::Image.from_blob(project_attachment.file_data).first
      thumb = original.columns > 120 ? original.resize_to_fit(120,120) : original
      thumb = thumb.border(1, 1, 'white')
      thumb.background_color = "none"
      thumb.rotate!(-5)
      thumb.trim!
      
      render :text => thumb.to_blob, :layout => false
    else
      render :text => "", :layout => false
    end
  end
  
  # コメントを編集する
  def ajax_update_comment
    param = params[:project_attachment]
    @project_attachment = ProjectAttachment.find(param[:id])
    @project_attachment.comment = param[:comment]
    @project_attachment.save
  end
end

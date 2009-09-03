module MeetingsHelper
  
  # ミーティングが削除可能かどうか
  def delete_meeting?
    return user_id == @meeting.create_user_id ? true : false
  end
  
  # ミーティングが閉会しているかどうか
  def closed?
    if !@meeting.nil? && !@meeting.open_flag
      return true
    end
    return false
  end
end

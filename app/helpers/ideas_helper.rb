module IdeasHelper
  
  # アイデアを削除できるか。作成ユーザにしか削除できない
  def delete_idea?
    return user_id == @idea.user_id ? true : false
  end
  
  # アイデアを編集できるか。作成ユーザにしか編集できない
  def edit_idea?
    return user_id == @idea.user_id ? true : false
  end
  
end

module ProjectsHelper
  
  # プロジェクトを削除できるか。作成ユーザにしか削除できない
  def delete_project?
    return user_id == @project.owner_id ? true : false
  end
  
end

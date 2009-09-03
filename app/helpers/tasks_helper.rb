module TasksHelper
  
  # タスクを削除できるか。作成ユーザにしか削除できない
  def delete_task?
    return user_id == @task.create_user_id ? true : false
  end
  
end

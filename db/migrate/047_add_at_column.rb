class AddAtColumn < ActiveRecord::Migration
  def self.up
    add_column(:users, :deleted_at, :datetime, :null => true)
    
    add_column(:divisions, :created_at, :datetime, :null => false)
    add_column(:divisions, :updated_at, :datetime, :null => false)
    add_column(:divisions, :deleted_at, :datetime, :null => true)
    
    add_column(:drecom_users, :created_at, :datetime, :null => false)
    add_column(:drecom_users, :updated_at, :datetime, :null => false)
    add_column(:drecom_users, :deleted_at, :datetime, :null => true)
    
    rename_column(:invite_users, :delete_at, :deleted_at)
    
    add_column(:meeting_agendas, :created_at, :datetime, :null => false)
    add_column(:meeting_agendas, :updated_at, :datetime, :null => false)
    add_column(:meeting_agendas, :deleted_at, :datetime, :null => true)
    
    add_column(:meeting_entry_users, :created_at, :datetime, :null => false)
    add_column(:meeting_entry_users, :updated_at, :datetime, :null => false)
    add_column(:meeting_entry_users, :deleted_at, :datetime, :null => true)
    
    add_column(:meeting_log_types, :created_at, :datetime, :null => false)
    add_column(:meeting_log_types, :updated_at, :datetime, :null => false)
    add_column(:meeting_log_types, :deleted_at, :datetime, :null => true)
    
    rename_column(:meeting_logs, :delete_at, :deleted_at)
    
    rename_column(:meetings, :delete_at, :deleted_at)
    
    add_column(:milestones, :created_at, :datetime, :null => false)
    add_column(:milestones, :updated_at, :datetime, :null => false)
    rename_column(:milestones, :delete_at, :deleted_at)
    
    add_column(:places, :created_at, :datetime, :null => false)
    add_column(:places, :updated_at, :datetime, :null => false)
    add_column(:places, :deleted_at, :datetime, :null => true)
    
    rename_column(:project_attachments, :delete_at, :deleted_at)
    
    add_column(:project_entry_guest_users, :created_at, :datetime, :null => false)
    add_column(:project_entry_guest_users, :updated_at, :datetime, :null => false)
    add_column(:project_entry_guest_users, :deleted_at, :datetime, :null => true)
    
    add_column(:project_entry_users, :created_at, :datetime, :null => false)
    add_column(:project_entry_users, :updated_at, :datetime, :null => false)
    add_column(:project_entry_users, :deleted_at, :datetime, :null => true)
    
    rename_column(:projects, :delete_at, :deleted_at)
    
    rename_column(:room_schedules, :delete_at, :deleted_at)
    
    add_column(:schedule_entry_users, :created_at, :datetime, :null => false)
    add_column(:schedule_entry_users, :updated_at, :datetime, :null => false)
    add_column(:schedule_entry_users, :deleted_at, :datetime, :null => true)
    
    rename_column(:schedules, :delete_at, :deleted_at)
    
    add_column(:statuses, :created_at, :datetime, :null => false)
    add_column(:statuses, :updated_at, :datetime, :null => false)
    add_column(:statuses, :deleted_at, :datetime, :null => true)
    
    rename_column(:task_logs, :delete_at, :deleted_at)
    
    rename_column(:tasks, :delete_at, :deleted_at)
    
    add_column(:users_divisions, :created_at, :datetime, :null => false)
    add_column(:users_divisions, :updated_at, :datetime, :null => false)
    add_column(:users_divisions, :deleted_at, :datetime, :null => true)
    
    rename_column(:wikis, :delete_at, :deleted_at)
  end

  def self.down
    remove_column(:users, :deleted_at)
    
    remove_column(:divisions, :created_at)
    remove_column(:divisions, :updated_at)
    remove_column(:divisions, :deleted_at)
    
    remove_column(:drecom_users, :created_at)
    remove_column(:drecom_users, :updated_at)
    remove_column(:drecom_users, :deleted_at)
    
    rename_column(:invite_users, :deleted_at, :delete_at)
    
    remove_column(:meeting_agendas, :created_at)
    remove_column(:meeting_agendas, :updated_at)
    remove_column(:meeting_agendas, :deleted_at)
    
    remove_column(:meeting_entry_users, :created_at)
    remove_column(:meeting_entry_users, :updated_at)
    remove_column(:meeting_entry_users, :deleted_at)
    
    remove_column(:meeting_log_types, :created_at)
    remove_column(:meeting_log_types, :updated_at)
    remove_column(:meeting_log_types, :deleted_at)
    
    rename_column(:meeting_logs, :deleted_at, :delete_at)
    
    rename_column(:meetings, :deleted_at, :delete_at)
    
    remove_column(:milestones, :created_at)
    remove_column(:milestones, :updated_at)
    rename_column(:milestones, :deleted_at, :delete_at)
    
    remove_column(:places, :created_at)
    remove_column(:places, :updated_at)
    remove_column(:places, :deleted_at)
    
    rename_column(:project_attachments, :deleted_at, :delete_at)
    
    remove_column(:project_entry_guest_users, :created_at)
    remove_column(:project_entry_guest_users, :updated_at)
    remove_column(:project_entry_guest_users, :deleted_at)
    
    remove_column(:project_entry_users, :created_at)
    remove_column(:project_entry_users, :updated_at)
    remove_column(:project_entry_users, :deleted_at)
    
    rename_column(:projects, :deleted_at, :delete_at)
    
    rename_column(:room_schedules, :deleted_at, :delete_at)
    
    remove_column(:schedule_entry_users, :created_at)
    remove_column(:schedule_entry_users, :updated_at)
    remove_column(:schedule_entry_users, :deleted_at)
    
    rename_column(:schedules, :deleted_at, :delete_at)
    
    remove_column(:statuses, :created_at)
    remove_column(:statuses, :updated_at)
    remove_column(:statuses, :deleted_at)
    
    rename_column(:task_logs, :deleted_at, :delete_at)
    
    rename_column(:tasks, :deleted_at, :delete_at)
    
    remove_column(:users_divisions, :created_at)
    remove_column(:users_divisions, :updated_at)
    remove_column(:users_divisions, :deleted_at)
    
    rename_column(:wikis, :deleted_at, :delete_at)
  end
end

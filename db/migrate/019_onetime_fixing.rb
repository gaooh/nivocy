class OnetimeFixing < ActiveRecord::Migration
  def self.up
    add_column(:meeting_logs, :created_at, :datetime, :null => false, :defalut=>Time.now)
    add_column(:meeting_logs, :updated_at, :datetime, :null => false, :defalut=>Time.now)
    add_column(:meeting_logs, :delete_at, :datetime, :null => true)
    
    rename_column(:meetings, :create_at, :created_at)
    add_column(:meetings, :updated_at, :datetime, :null => false, :defalut=>Time.now)
    add_column(:meetings, :delete_at, :datetime, :null => true)
    
    add_column(:projects, :created_at, :datetime, :null => false, :defalut=>Time.now)
    add_column(:projects, :updated_at, :datetime, :null => false, :defalut=>Time.now)
    add_column(:projects, :delete_at, :datetime, :null => true)
    
    rename_column(:task_logs, :create_at, :created_at)
    add_column(:task_logs, :updated_at, :datetime, :null => false, :defalut=>Time.now)
    add_column(:task_logs, :delete_at, :datetime, :null => true)
    
    rename_column(:tasks, :regist_at, :created_at)
    add_column(:tasks, :updated_at, :datetime, :null => false, :defalut=>Time.now)
    add_column(:tasks, :delete_at, :datetime, :null => true)
    
    remove_column(:users, :passwd)
    change_column(:users, :email, :string, :limit => 256, :null => false)
    add_column(:users, :created_at, :datetime, :null => false, :defalut=>Time.now)
    add_column(:users, :updated_at, :datetime, :null => false, :defalut=>Time.now)
    
    rename_column(:wikis, :create_at, :created_at)
  end

  def self.down
    remove_column(:meeting_logs, :created_at)
    remove_column(:meeting_logs, :updated_at)
    remove_column(:meeting_logs, :delete_at)
    
    rename_column(:meetings, :created_at, :create_at)
    remove_column(:meetings, :updated_at)
    remove_column(:meetings, :delete_at)
    
    remove_column(:projects, :created_at)
    remove_column(:projects, :updated_at)
    remove_column(:projects, :delete_at)
    
    rename_column(:task_logs, :created_at, :create_at)
    remove_column(:task_logs, :updated_at)
    remove_column(:task_logs, :delete_at)
    
    rename_column(:tasks, :created_at, :regist_at)
    remove_column(:tasks, :updated_at)
    remove_column(:tasks, :delete_at)
    
    add_column(:users, :passwd, :integer)
    change_column(:users, :email, :integer)
    remove_column(:users, :created_at)
    remove_column(:users, :updated_at)
    
    rename_column(:wikis, :created_at, :create_at)
    
  end
end

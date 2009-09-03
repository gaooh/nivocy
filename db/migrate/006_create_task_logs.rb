class CreateTaskLogs < ActiveRecord::Migration
  def self.up
    create_table :task_logs do |t|
      t.column "task_id",           :integer,  :null => false
      t.column "change_user_id",    :integer,  :null => false
      t.column "message",           :string,   :limit => 4000,   :null => false
      t.column "create_at",         :datetime,  :null => false
    end
  end

  def self.down
    drop_table :task_logs
  end
end

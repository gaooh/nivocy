class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column "project_id",        :integer,  :null => false
      t.column "milestone_id",      :integer,  :null => false
      t.column "create_user_id",    :integer,  :null => false
      t.column "treat_user_id",     :integer,  :null => false
      t.column "status_id",         :integer,  :null => false
      t.column "title",             :string,   :limit => 200,   :null => false
      t.column "content",           :string,   :limit => 4000,   :null => false
      t.column "regist_at",         :datetime,  :null => false
      t.column "goal_at",           :datetime,  :null => false
      t.column "complete_at",       :datetime,  :null => true
    end
  end

  def self.down
    drop_table :tasks
  end
end

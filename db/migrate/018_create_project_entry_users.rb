class CreateProjectEntryUsers < ActiveRecord::Migration
  def self.up
    create_table :project_entry_users do |t|
      t.column "project_id",    :integer,  :null => false
      t.column "user_id",       :integer,  :null => false
    end
  end

  def self.down
    drop_table :project_entry_users
  end
end

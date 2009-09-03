class CreateScheduleEntryUsers < ActiveRecord::Migration
  def self.up
    create_table :schedule_entry_users do |t|
      t.column "schedule_id",    :integer,  :null => false
      t.column "user_id",       :integer,  :null => false
    end
  end

  def self.down
    drop_table :schedule_entry_users
  end
end

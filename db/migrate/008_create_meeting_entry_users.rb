class CreateMeetingEntryUsers < ActiveRecord::Migration
  def self.up
    create_table :meeting_entry_users do |t|
      t.column "meeting_id",    :integer,  :null => false
      t.column "user_id",       :integer,  :null => false
    end
  end

  def self.down
    drop_table :meeting_entry_users
  end
end

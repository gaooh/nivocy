class CreateMeetingLogs < ActiveRecord::Migration
  def self.up
    create_table :meeting_logs do |t|
      t.column "meeting_id",             :integer,  :null => false
      t.column "voice",                  :string,   :limit => 2000,   :null => false
      t.column "voice_user_id",          :integer,  :null => true
      t.column "type_id",                :integer,  :null => true
    end
  end

  def self.down
    drop_table :meeting_logs
  end
end

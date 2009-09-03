class CreateMeetingLogTypes < ActiveRecord::Migration
  def self.up
    create_table :meeting_log_types do |t|
      t.column "name",                   :string,   :limit => 200,   :null => false
    end
  end

  def self.down
    drop_table :meeting_log_types
  end
end

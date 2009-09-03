class AddMeetingEndAt < ActiveRecord::Migration
  def self.up
    add_column(:meetings, :end_at, :datetime, :null => false)
    rename_column(:meetings, :holding_at, :start_at)
  end

  def self.down
    remove_column(:meetings, :end_at)
    rename_column(:meetings, :start_at, :holding_at)
  end
end

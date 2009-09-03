class AddAgendasId < ActiveRecord::Migration
  def self.up
    add_column(:meeting_logs, :meeting_agenda_id, :integer, :null => false)
  end

  def self.down
    remove_column(:meeting_logs, :meeting_agenda_id)
  end
end

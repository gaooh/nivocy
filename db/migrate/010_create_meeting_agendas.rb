class CreateMeetingAgendas < ActiveRecord::Migration
  def self.up
    create_table :meeting_agendas do |t|
      t.column "meeting_id",        :integer,  :null => false
      t.column "title",             :string,   :limit => 2000,   :null => false
    end
  end

  def self.down
    drop_table :meeting_agendas
  end
end

class AddAgendaPosition < ActiveRecord::Migration
  def self.up
    add_column(:meeting_agendas, :position, :integer, :null => false, :default => 1)
  end

  def self.down
    remove_column(:meeting_agendas, :position)
  end
end

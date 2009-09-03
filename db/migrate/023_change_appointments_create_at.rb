class ChangeAppointmentsCreateAt < ActiveRecord::Migration
  def self.up
    rename_column(:appointments, :create_at, :created_at)
    rename_column(:appointments, :update_at, :updated_at)
  end

  def self.down
    rename_column(:appointments, :created_at, :create_at)
    rename_column(:appointments, :updated_at, :update_at)
  end
end

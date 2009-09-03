class CreateProjectEntryGuestUsers < ActiveRecord::Migration
  def self.up
    create_table :project_entry_guest_users do |t|
      t.column "project_id",           :integer,  :null => false
      t.column "invite_user_id",       :integer,  :null => false
    end
  end

  def self.down
    drop_table :project_entry_guest_users
  end
end

class CreateDrecomUsers < ActiveRecord::Migration
  def self.up
    create_table :drecom_users do |t|
      t.column "email",              :string,     :limit => 256,   :null => false
    end
  end

  def self.down
    drop_table :drecom_users
  end
end

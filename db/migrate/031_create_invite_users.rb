class CreateInviteUsers < ActiveRecord::Migration
  def self.up
    create_table :invite_users do |t|
      t.column "email",              :string,     :limit => 256,   :null => false
      t.column "invite_code",        :string,     :limit => 32,    :null => false
      t.column "from_user_id",       :integer,    :null => false
      t.column "invite_at",          :datetime,   :null => true
      t.column "created_at",         :datetime,   :null => false
      t.column "updated_at",         :datetime,   :null => false
      t.column "delete_at",          :datetime,   :null => true
    end
  end

  def self.down
    drop_table :invite_users
  end
end

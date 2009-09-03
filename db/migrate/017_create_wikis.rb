class CreateWikis < ActiveRecord::Migration
  def self.up
    create_table :wikis do |t|
      t.column "project_id",        :integer,    :null => false
      t.column "create_user_id",    :integer,    :null => false
      t.column "title",             :string,     :limit => 200,    :null => false
      t.column "body",              :string,     :limit => 4000,   :null => false
      t.column "create_at",         :datetime,   :null => false
      t.column "update_at",         :datetime,   :null => false
      t.column "delete_at",         :datetime,   :null => false
    end
  end

  def self.down
    drop_table :wikis
  end
end

class CreateIdeas < ActiveRecord::Migration
  def self.up
    create_table :ideas do |t|
      t.column "user_id",              :integer,    :null => false
      t.column "idea_category_id",     :integer,    :null => false
      t.column "title",                :string,     :null => false, :limit => 200
      t.column "body",                 :text,       :null => false
      t.column "created_at",           :datetime,   :null => false
      t.column "updated_at",           :datetime,   :null => false
      t.column "deleted_at",           :datetime,   :null => true
    end
  end

  def self.down
    drop_table :ideas
  end
end

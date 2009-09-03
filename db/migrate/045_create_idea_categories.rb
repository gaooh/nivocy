class CreateIdeaCategories < ActiveRecord::Migration
  def self.up
    create_table :idea_categories do |t|
      t.column "name",                 :string,     :limit => 200,   :null => false
      t.column "created_at",           :datetime,   :null => false
      t.column "updated_at",           :datetime,   :null => false
      t.column "deleted_at",           :datetime,   :null => true
    end
  end

  def self.down
    drop_table :idea_categories
  end
end

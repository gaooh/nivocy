class CreateIdeaComments < ActiveRecord::Migration
  def self.up
    create_table :idea_comments do |t|
      t.column "idea_id",              :integer,    :null => false
      t.column "user_id",              :integer,    :null => false
      t.column "comment",              :text,       :null => false
      t.column "created_at",           :datetime,   :null => false
      t.column "updated_at",           :datetime,   :null => false
      t.column "deleted_at",           :datetime,   :null => true
    end
  end

  def self.down
    drop_table :idea_comments
  end
end

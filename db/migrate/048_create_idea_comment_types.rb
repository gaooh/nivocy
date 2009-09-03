class CreateIdeaCommentTypes < ActiveRecord::Migration
  def self.up
    create_table :idea_comment_types do |t|
      t.column "name",                 :string,     :limit => 200,   :null => false
      t.column "created_at",           :datetime,   :null => false
      t.column "updated_at",           :datetime,   :null => false
      t.column "deleted_at",           :datetime,   :null => true
    end
    
    add_column(:idea_comments, :idea_comment_type_id, :integer, :null => false)
  end

  def self.down
    drop_table :idea_comment_types
    remove_column(:idea_comments, :idea_comment_type_id)
  end
end

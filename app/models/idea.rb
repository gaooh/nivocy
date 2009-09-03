# == Schema Information
# Schema version: 49
#
# Table name: ideas
#
#  id               :integer(11)     not null, primary key
#  user_id          :integer(11)     not null
#  idea_category_id :integer(11)     not null
#  title            :string(200)     default(""), not null
#  body             :text            default(""), not null
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  deleted_at       :datetime        
#

class Idea < ActiveRecord::Base
  acts_as_paranoid
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :user
  belongs_to :idea_category
  has_many   :idea_comments
  
  # --------------------------
  # validatie
  # --------------------------
  validates_length_of   :title, :maximum => 200
  validates_presence_of :title, :body
  
  # 自分が投稿したアイデア
  def self.find_my_ideas(user_id, limit, offset)
    find(:all, :conditions => ["user_id = ?", user_id], :order => 'updated_at desc', :limit => limit, :offset => offset)
  end
  
  # 最近コメントがあったアイデア一覧
  def self.find_recent_comment_ideas(limit)
    idea_ids = Array.new
    idea_comments = IdeaComment.find_recent_comment_idea_ids(limit)
    idea_comments.each { |idea_comment| idea_ids << idea_comment.idea_id }
    find(idea_ids)
  end
  
  def self.count_ideas_by_word(word, idea_category_id)
    sql = search_query(word, idea_category_id)
    if sql.empty?
      count
    else
      count(:conditions => [sql])
    end
  end
  
  def self.find_ideas_by_word(word, idea_category_id, limit, offset)
    sql = search_query(word, idea_category_id)
    if sql.empty?
      find(:all, :order => 'updated_at desc', :limit => limit, :offset => offset)
    else
      find(:all, :conditions => [sql], :order => 'updated_at desc', :limit => limit, :offset => offset)
    end
  end
  
  # スコアを算出します。仕様は要検討
  def score
    comment_count = IdeaComment.count(:conditions => ['idea_id = ?', self.id])
    return comment_count
  end
  
  private
  
  def self.search_query(word, idea_category_id)
    sql = ''
    word_sql = get_ideas_by_word_sql(word)
    category_sql = get_ideas_by_idea_category_id_sql(idea_category_id)
    if !word_sql.empty? && !category_sql.empty?
      sql = "#{word_sql} and #{category_sql}" 
      
    else # 片方だけSQLが生成されているので場合はどちらかがはいる
      sql << word_sql
      sql << category_sql
    end
    return sql
  end
  
  def self.get_ideas_by_word_sql(word)
    words = word.gsub(/　/, ' ').strip.split(/ /)
    sql = ''
    
    words.each_with_index do |word,index|
      word = self.quote("%%#{word}%%") # sql injection 対策
      sql << " ( title like #{word} or body like #{word} ) "
      sql << " and " if word.length <= index
    end
    return sql
  end
  
  def self.get_ideas_by_idea_category_id_sql(idea_category_id)
    sql = ""
    unless idea_category_id.empty?
      idea_category_id = self.quote(idea_category_id) # sql injection 対策
      sql << " idea_category_id = #{idea_category_id} "
    end
    return sql
  end
end

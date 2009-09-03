# == Schema Information
# Schema version: 49
#
# Table name: users
#
#  id             :integer(11)     not null, primary key
#  office_id      :string(100)     default("")
#  email          :string(256)     default(""), not null
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  im             :string(256)     
#  log_input_type :integer(11)     not null
#  name           :string(200)     default(""), not null
#  password       :string(32)      default(""), not null
#  deleted_at     :datetime        
#

class User < ActiveRecord::Base
  LOG_INPUT_TYPE_STANDARD = 0
  LOG_INPUT_TYPE_ONELINER = 1
  
  # --------------------------
  # relation
  # --------------------------
  has_many :users_divisions
  has_many :divisions, :through=> :users_divisions, :conditions => "users_divisions.deleted_at IS NULL"
  has_many :meeting_entry_users
  
  # --------------------------
  # validation
  # --------------------------
  
  def initialize(arg)
    super(arg)
    self.log_input_type = LOG_INPUT_TYPE_STANDARD
  end
  
  #　既に登録済みのユーザかしらべる
  def self.find_registed_user(email, office_id) 
    if office_id.nil?
      find(:first, :conditions => ['email = ? and office_id is null ', email])
    else
      find(:first, :conditions => ['email = ? and office_id = ? ', email, office_id])
    end
  end
  
  # IM を利用するか。 TODO 別途フラグをもうけた場合はそちらをみるようにする
  def use_im?
    self.im.nil? ? false : true
  end
  
  # ログ記録モードが通常設定の場合trueがかえる
  def input_standard?
    self.log_input_type == LOG_INPUT_TYPE_STANDARD ? true : false
  end
  
  # ログ記録モードがワンライナー設定の場合trueがかえる
  def input_oneliner?
    self.log_input_type == LOG_INPUT_TYPE_ONELINER ? true : false
  end
  
  # 
  # 以下 drecm_ldap_login_system
  #
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = random_str(128)
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def office_id
    self.email.split('@')[0]
  end
  
  private
  def random_str(num)
    a_char = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    Array.new(num){a_char[rand(a_char.size)]}.join
  end
  
end

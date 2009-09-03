class <%= class_name %> < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

#  validates_presence_of     :login, :name, :email
#  validates_presence_of     :password,                   :if => :password_required?
#  validates_presence_of     :password_confirmation,      :if => :password_required?
#  validates_length_of       :password, :within => 4..40, :if => :password_required?
#  validates_confirmation_of :password,                   :if => :password_required?
#  validates_length_of       :login,    :within => 3..40
#  validates_length_of       :email,    :within => 3..100
#  validates_uniqueness_of   :login, :email, :case_sensitive => false

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
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

  private
  def random_str(num)
    a_char = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    Array.new(num){a_char[rand(a_char.size)]}.join
  end
end

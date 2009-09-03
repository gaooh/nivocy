require 'xmpp4r'
include Jabber

class NaviBotXmmp4r
  BOT_USER = 'nivocy@im.drecom.co.jp'
  BOT_PASS = '6Zx4UjtI'
  #BOT_USER = 'silver.vine.drecom@gmail.com'
  #BOT_PASS = 'sabosabo'
  
  def self.send_message(to, message)
    
    thread = Thread.new do
      client = Jabber::Client.new(Jabber::JID.new(BOT_USER))
      client.connect('im.drecom.co.jp', 5222)
      client.auth(BOT_PASS)

      client.send(Message::new(to, message))
      client.close
    end
    
  end
end
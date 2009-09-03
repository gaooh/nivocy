#!/usr/bin/ruby

require 'rubygems'
require 'xmpp4r'
include Jabber

class Xmmp4r
  def connect
    user = 'nivocy@im.drecom.co.jp'
    pass = '6Zx4UjtI'
    
    client = Jabber::Client.new(Jabber::JID.new("#{user}"))
    client.connect('im.drecom.co.jp', 5222)
    client.auth(pass)
    
    client.send(Message::new('asami@im.drecom.co.jp', "From test: aaa"))
    client.close
 end
end

xmpp4r = Xmmp4r.new
xmpp4r.connect
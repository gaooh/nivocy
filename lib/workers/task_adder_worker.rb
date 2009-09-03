require 'rubygems'
require 'xmpp4r'

class TaskAdderWorker < BackgrounDRb::Rails
      
  def do_work(args)
    begin
      @client = Jabber::Client.new(Jabber::JID.new(IM_SETTING[:user]))
      p @client.connect
      @client.auth(IM_SETTING[:password])
      @client.send(Jabber::Presence.new.set_show(:chat).set_status(IM_SETTING[:status]))
      loop do
        @client.process
        sleep(30)
      end
    rescue
      p $!
    end
  end

  def send_message(to, message)
    to_client = Jabber::JID.new(to)
    message = Jabber::Message::new(to_client, message).set_type(:normal).set_id('1')
    @client.send(message)
  end
  
end
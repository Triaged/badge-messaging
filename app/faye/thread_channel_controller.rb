class ThreadChannelController < FayeRails::Controller

	channel '/threads/messages/*' do
   
    monitor :subscribe do
      Emlogger.instance.log "Client #{client_id} subscribed to #{channel}."
      puts "Client #{client_id} subscribed to #{channel}."
    end
    
    monitor :unsubscribe do
      Emlogger.instance.log "Client #{client_id} unsubscribed from #{channel}."
    end
    
    monitor :publish do
      Emlogger.instance.log "Client #{client_id} published #{data.inspect} to #{channel}."
      
      thread = ThreadChannelController.message_thread(channel)
      response = Hashie::Mash.new(data)
      
      NewMessageController.new(thread, response).persist_and_deliver_message!
    end
  end

  channel '/threads/read/*' do
   
    monitor :subscribe do
      Emlogger.instance.log "Client #{client_id} subscribed to #{channel}."
      puts "Client #{client_id} subscribed to #{channel}."
    end
    
    monitor :unsubscribe do
      Emlogger.instance.log "Client #{client_id} unsubscribed from #{channel}."
    end
    
    monitor :publish do
      Emlogger.instance.log "Client #{client_id} published #{data.inspect} to #{channel}."
      
      thread = ThreadChannelController.message_thread(channel)
      response = Hashie::Mash.new(data)
      
      ReadMessageController.new(thread, response).read!
    end
  end



  def self.message_thread(channel)
    thread_id = /.*\/(.*)/.match(channel)[1]
    return MessageThread.find(thread_id)
  end

end


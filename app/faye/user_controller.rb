class UserController < FayeRails::Controller

	channel '/users' do
    monitor :subscribe do
      Emlogger.instance.log "A Client #{client_id} subscribed to #{channel}."
      puts "Client #{client_id} subscribed to #{channel}."
    end
    monitor :unsubscribe do
      Emlogger.instance.log "Client #{client_id} unsubscribed from #{channel}."
    end
    monitor :publish do
      Emlogger.instance.log "Client #{client_id} published #{data.inspect} to #{channel}."
    end
  end
end
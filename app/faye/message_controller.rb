class MessageController < FayeRails::Controller

	channel '/threads/messages/*' do
    monitor :subscribe do
      puts "Client #{client_id} subscribed to #{channel}."
    end
    monitor :unsubscribe do
      puts "Client #{client_id} unsubscribed from #{channel}."
    end
    monitor :publish do
      puts "Client #{client_id} published #{data.inspect} to #{channel}."
      thread = MessageThread.first
      thread.messages.create(
        author_id: data["author_id"],
        body: data["body"],
        timestamp: data["timestamp"]
      )
    end
  end

end
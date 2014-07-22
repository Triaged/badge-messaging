class UserController < FayeRails::Controller

	channel '/users/messages' do
    monitor :subscribe do
      Emlogger.instance.log "User #{client_id} subscribed to #{channel}."
      user = UserController.user(channel)
      Emlogger.instance.log "#{user}"
    end
    monitor :unsubscribe do
      Emlogger.instance.log "Client #{client_id} unsubscribed from #{channel}."
    end
    monitor :publish do
      Emlogger.instance.log "Client #{client_id} published #{data.inspect} to #{channel}."
    end
  end

  def self.user(channel)
    user_id = /.*\/(.*)/.match(channel)[1]
    return User.find_or_create_by(user_id: user_id)
  end
end
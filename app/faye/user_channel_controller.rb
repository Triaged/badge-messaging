class UserChannelController < FayeRails::Controller

	channel '/users/messages/*' do
    monitor :subscribe do
      Emlogger.instance.log "User #{client_id} subscribed to #{channel}."
      user = UserChannelController.user(channel)
      #PendingMessagesController.new(user).publish_pending_threads
      Emlogger.instance.log "#{user.id} subscriptions: #{user.subscriptions}"
    end
    monitor :unsubscribe do
      Emlogger.instance.log "User #{client_id} unsubscribed from #{channel}."
      user = UserChannelController.user(channel)
      Emlogger.instance.log "#{user.id} subscriptions: #{user.subscriptions}"
    end
    monitor :publish do
      Emlogger.instance.log "Client #{client_id} published #{data.inspect} to #{channel}."
    end
  end

  channel '/users/heartbeat/*' do
    monitor :subscribe do
      Emlogger.instance.log "User #{client_id} subscribed to #{channel}."
    end
    monitor :unsubscribe do
      Emlogger.instance.log "User #{client_id} unsubscribed from #{channel}."
    end
    monitor :publish do
      HeartbeatService.received_heartbeat(UserChannelController.user_id(channel))
      Emlogger.instance.log "Client #{client_id} published #{data.inspect} to #{channel}."
    end
  end

  def self.user(channel)
    user_id = UserChannelController.user_id(channel)
    return User.find_or_create_by(user_id: user_id)
  end

  def self.user_id (channel)
    return /.*\/(.*)/.match(channel)[1]
  end

end
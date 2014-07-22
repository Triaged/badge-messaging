class AuthExtension
  def incoming(message, callback)
    user_id = message['ext']['user_id']
    auth_token = message['ext']['auth_token']
    Emlogger.instance.log "Auth"

    # Subscription Auth
    if message['channel'] !~ %r{^/meta/subscribe}
      if User.find(user_id).valid_auth_token? auth_token
        Emlogger.instance.log "Subscription failed"
        message['error'] = '403::Authentication required'
      end
    end
    Emlogger.instance.log "subscribed auth"
    # Publish Message Auth
    if message['channel'] !~ %r{^/threads/messages}
      Emlogger.instance.log "publish auth"
      thread = message_thread(message['channel'])
      user = User.find(user_id)
      Emlogger.instance.log "publish auth1"
      if user.valid_auth_token?(auth_token) && thread.user_can_publish(user)
        Emlogger.instance.log "Subscription failed"
        message['error'] = '403::Authentication required'
      end
    end
    Emlogger.instance.log "published auth"
    callback.call(message)
  rescue
    Emlogger.instance.log "Rescueing, failed"
    message['error'] = '403::Authentication required'
    callback.call(message)
  end

  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing(message, callback)
    if message['ext'] && (message['ext']['auth_token'] || message['ext']['user_id'])
      message['ext'] = {} 
    end
    callback.call(message)
  end

  def message_thread(channel)
    thread_id = /.*\/(.*)/.match(channel)[1]
    return MessageThread.find(thread_id)
  end
end
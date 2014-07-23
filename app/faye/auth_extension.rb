class AuthExtension
  def incoming(message, callback)
    # Subscription Auth
    if message['channel'] =~ %r{^/meta/subscribe}
      user_id = message['ext']['user_id']
      auth_token = message['ext']['auth_token']
      unless User.find(user_id).valid_auth_token? auth_token
        message['error'] = '403::Authentication required'
      end
    end
    
    # Publish Message Auth
    if message['channel'] =~ %r{^/threads/messages/}
      user_id = message['ext']['user_id']
      auth_token = message['ext']['auth_token']
      
      thread = message_thread(message['channel'])
      user = User.find(user_id)
      
      unless user.valid_auth_token?(auth_token) && thread.user_can_publish(user)
        message['error'] = '403::Authentication required'
      end
    end

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
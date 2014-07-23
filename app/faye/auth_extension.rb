class AuthExtension
  def incoming(message, callback)
    # Subscription Auth
    if message['channel'] =~ %r{^/meta/subscribe}
      user_id = message['ext']['user_id']
      auth_token = message['ext']['auth_token']
      
      unless AuthenticationController.new(user_id, auth_token).authenticated?
        message['error'] = '403::Authentication required'
      end
      
    end
    
    # Publish Message Auth
    if message['channel'] =~ %r{^/threads/messages/}
      Emlogger.instance.log "publish"
      user_id = message['ext']['user_id']
      Emlogger.instance.log user_id
      auth_token = message['ext']['auth_token']
      Emlogger.instance.log auth_token
      thread = message_thread(message['channel'])
      Emlogger.instance.log thread
      Emlogger.instance.log "about to authenticate"
      
      unless AuthenticationController.new(user_id, auth_token).authenticated_and_can_publish? thread
        message['error'] = '403::Authentication required'
      end
      Emlogger.instance.log "publish done"
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
    Emlogger.instance.log thread
    return MessageThread.find(thread_id)
  end
end
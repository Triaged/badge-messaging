class AuthExtension
  def incoming(message, callback)
    #Emlogger.instance.log message.inspect
    # Subscription Auth
    # if message['channel'] =~ %r{^/meta/subscribe}
    #   user_id = message['ext']['user_id']
    #   auth_token = message['ext']['auth_token']
      
    #   unless AuthenticationService.new(user_id, auth_token).authenticated?
    #     message['error'] = '403::Authentication required'
    #   end
      
    # end
    
    # # Publish Message Auth
    # if message['channel'] =~ %r{^/threads/messages/}
    #   Emlogger.instance.log message['channel']
    #   user_id = message['ext']['user_id']
    #   auth_token = message['ext']['auth_token']
    #   thread = message_thread(message['channel'])
    #   Emlogger.instance.log thread
    #   Emlogger.instance.log "about to authenticate"
      
    #   unless AuthenticationService.new(user_id, auth_token).authenticated_and_can_publish? thread
    #     message['error'] = '403::Authentication required'
    #   end
    #   Emlogger.instance.log "publish done"
    # end

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
    Emlogger.instance.log "message thread"
    thread_id = /.*\/(.*)/.match(channel)[1]
    Emlogger.instance.log thread_id
    return MessageThread.find(thread_id)
  end
end
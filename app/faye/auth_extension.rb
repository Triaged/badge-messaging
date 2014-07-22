class AuthExtension
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      
      user_id = message['ext']['user_id']
      auth_token = message['ext']['auth_token']

      if User.find(user_id).valid_auth_token? auth_token
        message['error'] = 'Invalid authentication token'
      end
    end
    callback.call(message)
  rescue
    message['error'] = 'Invalid authentication token'
    callback.call(message)
  end

  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing(message, callback)
    if message['ext'] && (message['ext']['auth_token'] || message['ext']['user_id'])
      message['ext'] = {} 
    end
    callback.call(message)
  end
end
class AuthenticationController

	def initialize user_id, auth_token
		@user_id = user_id
		@auth_token = auth_token
	end

	def authenticated?
		Emlogger.instance.log "authenticated?"
		user = User.find_or_fetch @user_id
		Emlogger.instance.log user.inspect
		return user.valid_auth_token? @auth_token
	end

	def can_publish? thread
		user = User.find_or_fetch @user_id
		thread.user_can_publish(user)
	end

	def authenticated_and_can_publish? thread
		authenticated? && can_publish?(thread)
	end

end
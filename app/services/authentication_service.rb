class AuthenticationService

	def initialize user_id, auth_token
		@user_id = user_id
		@auth_token = auth_token
	end

	def authenticated?
		user = User.find_or_fetch @user_id
		return user.valid_auth_token? @auth_token
	end

	def can_publish? thread
		Emlogger.instance.log "can publish"
		user = User.find_or_fetch @user_id
		Emlogger.instance.log user
		thread.user_can_publish(user)
	end

	def authenticated_and_can_publish? thread
		Emlogger.instance.log "auth and publish"
		authenticated? && can_publish?(thread)
	end

end
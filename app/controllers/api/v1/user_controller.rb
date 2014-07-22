class Api::V1::UserController < ApiController

	def history
		respond_with current_user.message_threads
	end
end

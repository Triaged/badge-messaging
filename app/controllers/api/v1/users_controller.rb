class Api::V1::UsersController < ApiController

	def messages
		respond_with current_user.pending_message_threads_since(params[:timestamp] || 0)
	end
end

class Api::V1::UsersController < ApiController

	def messages
		timestamp = params[:timestamp] || 0
		respond_with current_user.pending_message_threads_since(timestamp), timestamp: timestamp
	end
end

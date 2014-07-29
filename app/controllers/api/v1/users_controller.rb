class Api::V1::UsersController < ApiController

	def messages
		timestamp = params[:timestamp] || 0
		@threads = current_user.pending_message_threads_since(timestamp), timestamp: timestamp.to_f
		render json: @threads, each_serializer: MessageThreadSerializer
	end
end

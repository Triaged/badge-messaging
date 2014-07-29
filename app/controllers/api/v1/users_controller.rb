class Api::V1::UsersController < ApiController

	def messages
		timestamp = params[:timestamp].to_f || 0
		@threads = current_user.pending_message_threads_since(timestamp)
		render json: @threads, each_serializer: MessageThreadSerializer, options: { timestamp: timestamp }
	end
end

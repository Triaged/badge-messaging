class Api::V1::UsersController < ApiController

	def messages
		timestamp = params[:timestamp].to_f || 0
		@threads = current_user.message_threads_since(timestamp)
		render json: @threads, each_serializer: MessageThreadSerializer, root: false, { timestamp: timestamp }
	end
end

class Api::V1::MessageThreadsController < ApplicationController

	def create
		@message_thread = MessageThread.create(message_thread_params)
		respond_with @message_thread.to_json
	end

private
	
	def message_thread_params
		params[:message_thread].permit(:user_ids)
	end
end

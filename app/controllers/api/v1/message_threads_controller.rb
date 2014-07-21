class Api::V1::MessageThreadsController < ApplicationController
	respond_to :json

	def show
		@message_thread = MessageThread.find(params[:id])
		respond_with @message_thread
	end

	def create
		puts params[:message_thread]
		puts message_thread_params
		@message_thread = MessageThread.create(message_thread_params)
		respond_with @message_thread.to_json, location: api_v1_message_thread_path(@message_thread)
	end

private
	
	def message_thread_params
		params[:message_thread].permit(:user_ids)
	end
end

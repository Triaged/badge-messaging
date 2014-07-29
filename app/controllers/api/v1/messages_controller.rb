class Api::V1::MessagesController < ApplicationController
	respond_to :json
	protect_from_forgery with: :null_session

	def create
		@message = MessageThread.in(user_ids: ["6"]).first.messages.new(message_params)
		respond_with @message
	end

	def message_params
		params[:message].permit(:author_id, :body, :timestamp)
	end


end

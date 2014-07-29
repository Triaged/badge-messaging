class Api::V1::MessagesController < ApplicationController
	respond_to :json
	protect_from_forgery with: :null_session

	def create
		thread = MessageThread.in(user_ids: ["6"]).first
    response = Hashie::Mash.new({message: message_params, guid: "2342342523")
    NewMessageService.new(thread, response).persist_and_deliver_message!

		render :json => { "message" => "ok" }, :status => 200
	end

	def message_params
		params[:message].permit(:author_id, :body, :timestamp)
	end


end

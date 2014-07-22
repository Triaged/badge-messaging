class Api::V1::MessageThreadsController < ApiController
	respond_to :json

	def show
		@message_thread = MessageThread.find(params[:id])
		respond_with @message_thread
	end

	def create
		recipients = message_thread_params[:user_ids]
		
		unless recipients.include? current_user.id 
			render :json => { :errors => ['Invalid MessageThread, current user must be part of thread'] }, :status => 401 && return
		end
		
		@message_thread = MessageThread.find_or_create_by(user_ids: )
		respond_with @message_thread.to_json, location: api_v1_message_thread_path(@message_thread)
	end

private
	
	def message_thread_params
		params[:message_thread].permit(:user_ids => [])
	end
end

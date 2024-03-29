class Api::V1::MessageThreadsController < ApiController
	respond_to :json

	def show
		@message_thread = MessageThread.find(params[:id])
		respond_with @message_thread
	end

	def create
		# Emlogger.instance.log "*** BEGIN RAW REQUEST HEADERS ***"
		# self.request.env.select {|k,v| k.match("^HTTP.*")}.each do |header|
  # 		Emlogger.instance.log "HEADER KEY: #{header[0]}"
  # 		Emlogger.instance.log "HEADER VAL: #{header[1]}"
		# end
		# Emlogger.instance.log "*** END RAW REQUEST HEADERS ***"

		recipients = message_thread_params[:user_ids]
		recipients = recipients.collect{ |i| i.to_s}

		unless recipients.include?(current_user.id)
			render(:json => { :errors => ['Invalid MessageThread, current user must be part of thread'] }, :status => 401) && return
		end
		
		@message_thread = MessageThread.all(user_ids: recipients).where(:user_ids.with_size => recipients.length).first
		@message_thread = MessageThread.create(user_ids: recipients) unless @message_thread
		
		respond_with @message_thread, location: api_v1_message_thread_path(@message_thread)
	end

private
	
	def message_thread_params
		params[:message_thread].permit(:user_ids => [])
	end
end
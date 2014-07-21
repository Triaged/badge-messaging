class MessageController < FayeRails::Controller

	channel '/threads/**' do
    monitor :subscribe do
      Rails.logger.info "Client #{client_id} subscribed to #{channel}."
    end
    monitor :unsubscribe do
      Rails.logger.info "Client #{client_id} unsubscribed from #{channel}."
    end
    monitor :publish do
      Rails.logger.info "Client #{client_id} published #{data.inspect} to #{channel}."


    end
  end

end
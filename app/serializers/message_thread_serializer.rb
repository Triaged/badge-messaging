class MessageThreadSerializer < ActiveModel::Serializer
  attributes :id, :user_ids, :u_at

  has_many :messages

  def messages
  	Rails.logger.info @options.inspect
  	return @options[:messages] if @options[:messages]
  	return object.messages.where(:c_at.gt => @options[:timestamp]) if @options[:timestamp]
  	return object.messages
  end
end

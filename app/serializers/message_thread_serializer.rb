class MessageThreadSerializer < ActiveModel::Serializer
  attributes :id, :user_ids, :u_at, :timestamp

  has_many :messages

  def messages
  	return @options[:messages] if @options[:messages]
  	return object.messages.where(:timestamp.gt => @options[:timestamp]) if @options[:timestamp]
  	return object.messages
  end
end

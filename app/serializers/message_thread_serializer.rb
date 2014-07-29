class MessageThreadSerializer < ActiveModel::Serializer
  attributes :id, :user_ids

  has_many :messages

  def messages
  	return @options[:messages] if @options[:messages]
  	return self.messages.where(:c_at.gte => @options[:timestamp]) if @options[:timestamp]
  	return object.messages
  end
end

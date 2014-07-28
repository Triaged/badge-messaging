class MessageThreadSerializer < ActiveModel::Serializer
  attributes :id, :user_ids

  has_many :messages

  def messages
  	@options[:messages] || object.messages
  end
end

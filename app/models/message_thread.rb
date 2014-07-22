class MessageThread
  include Mongoid::Document

  has_and_belongs_to_many :users
	embeds_many :messages

	def with_last_message_as_json
		{
			user_ids: self.user_ids,
			messages: [self.messages.last]
		}
	end

	
end

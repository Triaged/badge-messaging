class MessageThread
  include Mongoid::Document

  has_and_belongs_to_many :users
	embeds_many :messages

	def with_last_message
		{
			user_ids: self.user_ids,
			messages: [self.messages.last]
		}
	end

	def with_message message
		{
			user_ids: self.user_ids,
			messages: [message]
		}
	end

	
end

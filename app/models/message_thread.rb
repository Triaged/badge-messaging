class MessageThread
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  has_and_belongs_to_many :users
	embeds_many :messages

	def user_can_publish user 
		self.user_ids.include? user.id
	end

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

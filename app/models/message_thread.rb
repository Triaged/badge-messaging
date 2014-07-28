class MessageThread
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  has_and_belongs_to_many :users, autosave: true
	embeds_many :messages, cascade_callbacks: true
	accepts_nested_attributes_for :messages

	def user_can_publish user 
		self.user_ids.include? user.id
	end

	def with_last_message
		{
			_id: self.id.to_s,
			user_ids: self.user_ids,
			messages: [self.messages.last]
		}
	end

	def with_message message
		{
			_id: self.id.to_s,
			user_ids: self.user_ids,
			messages: [message]
		}
	end

	def with_messages_since timestamp
		{
			_id: self.id.to_s,
			user_ids: self.user_ids,
			messages: [self.messages.where(:c_at.gte => timestamp)]
		}
	end
end

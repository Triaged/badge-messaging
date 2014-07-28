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
		MessageThreadSeralizer.new(self, { messages: self.messages.last }).to_json
	end

	def with_message message
		MessageThreadSeralizer.new(self, { messages: message }).to_json
	end

	def with_messages_since timestamp
		MessageThreadSeralizer.new(self, { messages: self.messages.where(:c_at.gte => timestamp) }).to_json
	end
end

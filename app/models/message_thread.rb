class MessageThread
  include Mongoid::Document

  has_and_belongs_to_many :users
	embeds_many :messages

	def as_json
		{
			id: self.id.to_s,
			users: self.users,
			messages: self.messages.as_json
		}

	end
end

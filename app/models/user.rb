class User
  include Mongoid::Document

  field :_id, type: String, default: -> { user_id }
  field :user_id, type: String
  field :subscriptions, type: Integer
  field :authentication_token, type: String

  has_and_belongs_to_many :message_threads

  def valid_auth_token? auth_token
		if self.authentication_token && (self.authentication_token == auth_token)
  		return true
  	else
  		valid = check_auth_token_with_remote auth_token
  		self.update_attribute(:authentication_token, auth_token) if valid
  		return valid
  	end
	end

  def check_auth_token_with_remote auth_token
  	BadgeClient.new.valid_auth_token_for_user(self.id, auth_token)
  end
end

class BadgeClient
	include HTTParty
	base_uri ENV["BADGE_BASE_URL"]

	def initialize
		@options = {
      :headers => {        
        'Content-Type' => 'application/json',          
        'Accept' => '*/*',
        'Authorization' => ENV["INTERNAL_API_TOKEN"]
      }          
    } 
	end

	def user user_id
		response = self.class.get("/users/#{user_id}", @options)
		raise HTTParty::Error.new unless response.response.is_a?(Net::HTTPSuccess) 

		return Hashie::Mash.new(response.parsed_response)
	end

	def deliver_message user_id, message
		params = @options.merge(query: {message: message})
		response = self.class.post("/users/#{user_id}/deliver_message", params)
		raise HTTParty::Error.new unless response.response.is_a?(Net::HTTPSuccess) 
	end

	def valid_auth_token_for_user user_id, auth_token
		params = @options.merge(query: {authentication_token: auth_token })
		response = self.class.get("/users/#{user_id}/valid_auth_token", params)
		puts response.inspect
		raise HTTParty::Error.new unless response.response.is_a?(Net::HTTPSuccess) 

		return to_boolean(response.parsed_response["success"])
	end

	def to_boolean(s)
  	!!(s =~ /^(true|t|yes|y|1)$/i)
	end

end
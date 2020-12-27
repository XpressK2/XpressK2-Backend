module V1::Authentications::Firebase
  class Signup
    attr_accessor :error, :user_data

    def initialize(id_token:)
      @id_token = id_token
    end

    def call
      do_request
      validate_response
      create_user
    rescue StandardError => e
      self.error = e.message
    ensure
      return self
    end

    def success?
      self.error.blank?
    end

    private

    API_KEY = Rails.application.credentials.dig(:FIREBASE, :API_KEY)

    attr_reader :id_token, :response

    def do_request
      response_body = Net::HTTP.post(URI(url), payload.to_json, headers).body
      @response = JSON.parse(response_body)
    end

    def validate_response
      if invalid_response?
        self.error = response.dig('error', 'message')
      end
    end

    def invalid_response?
      response['error'].present?
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

    def payload
      { id_token: id_token }
    end

    def url
      "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=#{API_KEY}"
    end

    def create_user
      return if !success? || user.blank?

      initialize_user = \
        User.find_or_initialize_by(
          local_id: user['localId'],
          name: user['displayName'],
          email: user['email'],
          third_party: true
        )
      initialize_user.password = user['passwordHash'] 
      if initialize_user.save(validate: false)
        @user_data = initialize_user
      end
    end

    def user
      @user ||= response['users'].first
    end
  end
end

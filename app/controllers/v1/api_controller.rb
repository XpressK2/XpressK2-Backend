class V1::ApiController < ApplicationController
  include JsonResponders
  include ExceptionHandler
  include MissingData
  include Consul::Controller

  attr_reader :current_user

  before_action :validate_api_accessors
  # before_action :authenticate_user!
  # before_action :set_locale
  # require_power_check

  private

  # Set Power and inject it with current user
  current_power do
    Power.new(current_user)
  end

  # Set request locale
  def set_locale
    I18n.locale = params[:locale] || request.headers['locale'] || I18n.default_locale
  end

  def validate_api_accessors
    return if request.headers['API-ACCESSOR'] == api_accessor_token

    render_forbidden(error: 1301)
  end

  def api_accessor_token
    Rails.application.credentials.dig(:EXPRESS, :API_ACCESSOR_TOKEN)
  end
end

# frozen_string_literal: true

class V1::Auth::SignupController < V1::BaseController
  power :signups, map: {
    [:create]  => :creatable_signup,
    [:google] => :google_signup,
    [:facebook] => :facebook_signup
  }, as: :signups_scope

  ## ------------------------------------------------------------ ##

  # POST : /v1/auth/signup
  # Inherited from V1::BaseController
  # def create; end

  ## ------------------------------------------------------------ ##

  # POST : /v1/auth/signup/google
  def google
    return if missing_params!(:id_token)

    signup = V1::Authentications::Firebase::Signup.new(id_token: params[:id_token]).call

    if signup.success?
      data = { show_key => signup.user_data.as_api_response(show_template) }
      render_success(data: data, message: created_message)
    else
      render_unprocessable_entity(message: signup.error)
    end
  end

  ## ------------------------------------------------------------ ##

  # POST : /v1/auth/signup/facebook
  def facebook
    return if missing_params!(:id_token)

    signup = V1::Authentications::Firebase::Signup.new(id_token: params[:id_token]).call

    if signup.success?
      data = { show_key => signup.user_data.as_api_response(show_template) }
      render_success(data: data, message: created_message)
    else
      render_unprocessable_entity(message: signup.error)
    end
  end

  ## ------------------------------------------------------------ ##


  private

  def signup_params
    params.require(:signup).permit(
      :name, :email, :password, :country_code,
      :telephone_no, :country, :trade_role
    )
  end

  def get_scope
    User
  end

  def created_message
    I18n.t('signup.success')
  end

  def show_key
    'user'
  end
end

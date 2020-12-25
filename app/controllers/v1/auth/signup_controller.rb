# frozen_string_literal: true

class V1::Auth::SignupController < V1::BaseController
  power :signups, map: {
    [:create]  => :creatable_signup,
  }, as: :signups_scope

  ## ------------------------------------------------------------ ##

  # POST : /v1/auth/signup
  # Inherited from V1::BaseController
  # def create; end

  ## ------------------------------------------------------------ ##

  private

  # Whitelist parameters
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

  # Search filters
  # def search_params; end

  # Custom ordering and sorting
  # def get_order; end
end

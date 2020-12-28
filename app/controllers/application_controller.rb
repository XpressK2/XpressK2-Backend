class ApplicationController < ActionController::API
  def status
    render json: {
      success: true,
      message: 'Xpressk backend server is up',
      env: Rails.env
    }
  end
end

class ApiController < ApplicationController
  before_action :set_default_format
  before_action :authenticate

  def show
    render json: {
      message: "API for diaper partner app"
    }
  end

  private

  def set_default_format
    request.format = :json
  end

  def api_key_valid?
    return true if Rails.env.development?

    request.headers["X-Api-Key"] == ENV["DIAPER_KEY"]
  end

  def authenticate; end
end
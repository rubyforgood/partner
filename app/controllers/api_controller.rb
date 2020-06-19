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

    # This prevents a scenario where an unauthorized request would be allowed access if
    # both the environment variable is nil (not set) and the request header is missing,
    # also nil as both would positively match on nil values
    return false if ENV["DIAPER_KEY"].blank?

    request.headers["X-Api-Key"] == ENV["DIAPER_KEY"]
  end

  def authenticate; end
end
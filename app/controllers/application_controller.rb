class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordInvalid do |exception|
    Rails.logger.error(exception.message)

    exception.backtrace.each do |line|
      Rails.logger.error(line)
    end
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  rescue_from ActiveModel::ValidationError do |exception|
    render json: { errors: exception.model.errors.full_messages }, status: :unprocessable_entity
  end

  def after_sign_out_path_for(*)
    new_partner_session_path
  end

  private

  def user_not_authorized
    redirect_to(request.referer || root_path, notice: "You are not authorized to perform this action.")
  end
end

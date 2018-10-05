class ApplicationController < ActionController::Base
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
end

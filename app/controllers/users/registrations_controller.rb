# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    before_action :configure_sign_up_params, only: [:create]

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: {
          status: 200,
          message: 'Signed up sucessfully'
        }, status: :ok
      else
        render json: {
          status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[email name password])
    end
  end
end

# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    respond_with(@user)
  end

  def destroy
    @user = current_user
    @user.destroy

    render json: { message: 'Registration deleted successfully' }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password)
  end
end

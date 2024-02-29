class Api::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  def tasks
    user = User.find(params[:user_id])
    tasks = user.tasks
    render json: tasks
  end

  private

  def user_not_found
    render json: { error: 'User not found' }, status: :not_found
  end
end

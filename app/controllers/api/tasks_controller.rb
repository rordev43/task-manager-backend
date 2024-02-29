class Api::TasksController < ApplicationController
  before_action :set_task, only: [:update, :destroy, :assign, :progress]

  def create
    task = Task.new(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update_with_completion(task_params)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  def index
    tasks = Task.all
    render json: tasks
  end

  def assign
    if @task.assign_to_user(params[:user_id])
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def progress
    if @task.update_progress(params[:progress])
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def overdue
    overdue_tasks = Task.overdue
    render json: overdue_tasks
  end

  def status
    tasks = Task.by_status(params[:status])
    render json: tasks
  end

  def completed
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    completed_tasks = Task.completed_within_range(start_date, end_date)
    render json: completed_tasks
  end

  def statistics
    statistics = Task.statistics
    render json: statistics
  end

  private

  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Task not found' }, status: :not_found
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status, :progress)
  end
end

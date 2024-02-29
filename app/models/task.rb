class Task < ApplicationRecord
  belongs_to :user, optional: true

  PRIORITY_LEVELS = {
    high: 3,
    medium: 2,
    low: 1
  }.freeze

  validates :title, :description, :due_date, :priority, presence: true
  validates :priority, inclusion: { in: PRIORITY_LEVELS.keys.map(&:to_s) }
  
  before_validation :set_default_priority

  scope :ordered_tasks, -> { order('priority DESC, due_date ASC') }

  def self.overdue
    where('due_date < ?', Date.today)
  end

  def self.by_status(status)
    where(status: status)
  end

  def self.completed_within_range(start_date, end_date)
    where(completed_date: start_date..end_date).where.not(completed_date: nil)
  end

  def self.statistics
    total_tasks = count
    completed_tasks = where.not(completed_date: nil).count
    percentage_completed = (completed_tasks.to_f / total_tasks) * 100
    {
      total_tasks: total_tasks,
      completed_tasks: completed_tasks,
      percentage_completed: percentage_completed
    }
  end

  def update_with_completion(params)
    if update(params)
      update(completed_date: Time.now) if status_changed_to_completed?
      true
    else
      false
    end
  end

  def assign_to_user(user_id)
    user = User.find_by(id: user_id)
    if user
      self.user = user
      save
    else
      errors.add(:user_id, "User not found")
      false
    end
  end

  def update_progress(progress)
    self.progress = progress
    save
  end

  private

  def set_default_priority
    self.priority ||= 'medium'
  end

  def status_changed_to_completed?
    status_changed? && status == 'Completed'
  end
end

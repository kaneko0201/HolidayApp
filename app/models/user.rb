class User < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :people, presence: true
  validates :budget, presence: true
  validates :location, presence: true
  validates :mood, presence: true
  validate :end_date_after_start_date
  validate :within_five_days

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "は開始日以降の日付を選択してください")
    end
  end

  def within_five_days
    return if start_date.blank? || end_date.blank?

    if (end_date - start_date).to_i > 5
      errors.add(:end_date, "は開始日から5日以内の日付を選択してください")
    end
  end
end

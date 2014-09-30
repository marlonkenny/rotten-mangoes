class Movie < ActiveRecord::Base

  validates :title, :director, :description, :poster_image_url, :release_date,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validate :release_date_is_in_the_future

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, 'should probably be in the future') if release_date < Date.today
    end
  end

end

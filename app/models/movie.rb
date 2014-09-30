class Movie < ActiveRecord::Base
  has_many :reviews
  has_many :cast_members
  has_many :actors, through: :cast_members
  
  validates :title, :director, :description, :poster_image_url, :release_date,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }


  def review_average
    return 0 if reviews.size < 1
    reviews.sum(:rating_out_of_ten)/reviews.size
  end

end

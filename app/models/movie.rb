class Movie < ActiveRecord::Base
  has_many :reviews
  has_many :cast_members
  has_many :actors, through: :cast_members
  
  validates :title, :director, :description, :release_date,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  mount_uploader :image, ImageUploader

  def review_average
    return 0 if reviews.size < 1
    reviews.sum(:rating_out_of_ten)/reviews.size
  end

  def self.search(search)
    if search
      title_search(search['title']).director_search(search['director'])
    else
      all
    end
  end
  
  def self.title_search(title)
    where('title LIKE ?', "%#{title}%")
  end

  def self.director_search(director)
    where('director LIKE ?', "%#{director}%")
  end
end

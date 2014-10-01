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
      search_like(search['query']).duration(search['duration'])
    else
      all
    end
  end

  scope :search_like, ->(query) { where('title LIKE :q OR director LIKE :q', q: "%#{query}%")}

  scope :runtime_over, ->(time) { where('runtime_in_minutes >= ?', time) }
  scope :runtime_under, ->(time) { where('runtime_in_minutes <= ?', time) }

  def self.duration(duration)
    case duration
    when 'any'
      all
    when '90'
      runtime_under(90)
    when '90_120'
      runtime_over(90).runtime_under(120)
    when '120'
      runtime_over(120)
    end
  end
end

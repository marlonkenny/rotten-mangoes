class Movie < ActiveRecord::Base
  belongs_to :director
  has_many :reviews
  has_many :cast_members
  has_many :actors, through: :cast_members
  
  validates :title,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }, allow_blank: :true

  mount_uploader :image, ImageUploader

  scope :search_like, ->(query) { where('title LIKE :q OR director LIKE :q', q: "%#{query}%")}

  scope :runtime_over, ->(time) { where('runtime_in_minutes >= ?', time) if !time.blank? }
  scope :runtime_under, ->(time) { where('runtime_in_minutes <= ?', time) if !time.blank? }

  def self.search(search)
    if search
      search_like(search['query']).runtime_over(search['duration_a']).runtime_under(search['duration_b'])
    else
      all
    end
  end

  def review_average
    return 0 if reviews.size < 1
    reviews.sum(:rating_out_of_ten)/reviews.size
  end
end

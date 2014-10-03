class AddRtScoreFieldToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :rt_score, :string
  end
end

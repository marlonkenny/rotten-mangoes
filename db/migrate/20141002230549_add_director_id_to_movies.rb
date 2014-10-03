class AddDirectorIdToMovies < ActiveRecord::Migration
  def change
    add_reference :movies, :director, index: true
  end
end

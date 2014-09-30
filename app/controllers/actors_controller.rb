class ActorsController < ApplicationController
  def new
    @actor = Actor.new
    @all_movies = Movie.all
    @actor_movies = @actor.movies
  end

  def create
    @actor = Actor.create(actor_params)

    if @actor.save
      redirect_to movies_path, notice: "#{@actor.firstname} #{@actor.lastname} was added successfully."
    else
      render :new
    end
  end

  protected

  def actor_params
    params.require(:actor).permit(:firstname, :lastname, :gender, :birthdate, movies:[])    
  end
end

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings()
    
    ratings = params[:ratings]
    sort = params[:sort]
    
    if session.has_key? :ratings or session.has_key? :sort
      if not params.has_key? :ratings and not params.has_key? :sort and not params.has_key? "commit"
        redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort])
      end
    end
    
    if ratings != nil
      @movies = Movie.with_ratings(ratings.keys.map(&:downcase))
      @ratings_to_show = ratings.keys
    else
      @movies = Movie.with_ratings(nil)
      @ratings_to_show = Movie.all_ratings()
    end
    
    if sort != nil
      if sort == "movie_title"
        @movies = @movies.sort_by("title")
        @title_header = "hilite text-success"
      else 
        @movies = @movies.sort_by("release_date")
        @release_date_header = "hilite text-success"
      end
    end
    
    session[:ratings] = ratings
    session[:sort] = sort
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

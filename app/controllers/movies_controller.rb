class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all

    # check if there are existing settings
    if params[:ratings].nil? and params[:sortby].nil?
      if not session[:ratings].nil? or not session[:sortby].nil?
        redirect_to movies_path(:sortby => session[:sortby], :ratings => session[:ratings])
      end
    end

    if params[:ratings].nil?
      @ratings = Movie.ratings
    else
      @ratings = params[:ratings]
    end
    session[:ratings] = @ratings

    # if there are some ratings checked, then filter out movies of other ratings
    @movies = @movies.find_all { |m| @ratings.include?(m.rating) }

    # sort by title or release date if column header was clicked
    if params[:sortby] == 'title'
      @movies = @movies.sort_by { |m| m.title }
      @title_header_class = 'hilite'
    elsif params[:sortby] == 'release_date'
      @movies = @movies.sort_by { |m| m.release_date }
      @release_date_header_class = 'hilite'
    end
    session[:sortby] = params[:sortby]

    # make all_ratings hash with boolean value representing whether or not box is checked
    @all_ratings = Hash.new # needed for check boxes with possible ratings
    Movie.ratings.each do |rating|
      if not @ratings.nil? and @ratings.include?(rating)
        @all_ratings[rating] = true
      else
        @all_ratings[rating] = false
      end
    end
end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

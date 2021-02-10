class MoviesController < ApplicationController
  helper_method :hilite

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   @all_ratings = Movie.rating

   @ratings_to_show = []
   @sort = params[:sort]
   ratings = []
   @ratings = params[:ratings]
   
   if @ratings.nil?
     ratings = Movie.rating 
   else
     ratings = @ratings.keys
   end
#    @ratings1 = []
    
#    if !params[:ratings].nil?
#      if !params[:ratings].keys.nil?
   @ratings_to_show = ratings
#        @ratings1 = params[:ratings].keys
   @movies = Movie.with_ratings(@ratings_to_show)
#      end
#    else
# #      @ratings1 = Movie.rating
#      @ratings_to_show = Movie.rating
#      @movies = Movie.all
#    end
    
   if !@sort.nil? 
#       if @sort == "title"
#         @hilite_title = "p-3 mb-2 bg-warning text-dark"
#       elsif @sort == "release_date"
#         @hilite_release_date = "p-3 mb-2 bg-warning text-dark"
#       elsif @sort == "release_date"
#       end
      begin
#         if !params[:ratings].nil?
#           if !params[:ratings].keys.nil?
        @movies = Movie.order("#{@sort} ASC").with_ratings(ratings)
#           end
#         end
      rescue ActiveRecord::StatementInvalid
        flash[:warning] = "Movies cannot be sorted by #{@sort}."
        @movies = Movie.with_ratings(ratings)
      end
   else
      @movies = Movie.with_ratings(ratings)
   end
    
      
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
  
#   def hilite
#     @sort = params[:sort]
#     if !@sort.nil?
      
#     end
#   end

  def hilite(column)
    if @sort == column
      return "p-3 mb-2 bg-warning text-dark"
    else
      return nil
    end
  end
  
  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

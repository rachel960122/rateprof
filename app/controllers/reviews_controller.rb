class ReviewsController < ApplicationController
	before_action :set_professor
	before_action :set_review, except: [:new, :create]
	before_action :authenticate_user!
  before_filter :authorize, only: [:edit, :destroy]

  def new
  end

  def create
    @review = @professor.reviews.create(review_params)
    @review.user_id = current_user.id
    if @review.save
    	redirect_to @professor
    else
    	render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
  	if @review.update(review_params)
  		redirect_to @professor
  	else
  		render 'edit'
  	end
  end

  def destroy
  	@review.destroy
  	redirect_to @professor
  end

  protected

    def authorize
      unless admin?
        flash[:error] = "Unauthorized Access"
        redirect_to professor_review_path(@professor, @review)
        false
      end
    end
 
  private

  	def set_review
  		@review = Review.find(params[:id])
  	end

  	def set_professor
  		@professor = Professor.find(params[:professor_id])
  	end

    def review_params
      params.require(:review).permit(:rating, :classname, :comment)
    end
end

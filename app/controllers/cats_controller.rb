class CatsController < ApplicationController

  before_action :is_owner, only: [:edit, :update]

  helper_method :is_owner?, :cat_rental_requests

  def index
    @cats = Cat.all
    current_user
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat)
      .permit(:age, :birth_date, :color, :description, :name, :sex)
  end

  def logged_out?
    redirect_to new_session_url unless current_user
  end

  def is_owner
    unless current_user.cats.where(id: params[:id].to_i).exists?
    # map(&:id).include?(params[:id].to_i)
      flash.now[:errors] = ["This isn't your cat!"]
      redirect_to cats_url
    end
  end

  def is_owner?
    current_user.cats.where(id: params[:id].to_i).exists?
  end

  def cat_rental_requests
    @cat.rental_requests.includes(:requester).order("start_date")
  end
end

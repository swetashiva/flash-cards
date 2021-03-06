class StudySetsController < ApplicationController

  before_action :authenticate_user!, except: [:show, :index, :sort]

  def create
    if user_verified?
      @study_set = current_user.study_sets.new(study_set_params)
      if @study_set.save
        current_user.study_sets << @study_set
        current_user.save
        redirect_to user_path(current_user)
      else
        render :new
      end
    else
      whoops
    end
  end

  def update
    if user_verified?
      @study_set = StudySet.find_by_id(params[:id])
      if @study_set.update(study_set_params)
        redirect_to user_path(current_user)
      else
        render :edit
      end
    else
      whoops
    end
  end

  def index
    if params[:search]
      @study_sets = StudySet.search(params[:search]).order("created_at DESC")
    else
      @study_sets = StudySet.all.order("created_at DESC")
    end
    respond_to do |f|
      f.html { render :index }
      f.json { render json: @study_sets }
    end
  end

  def new
    if user_verified?
      @study_set = StudySet.new(owner_id: params[:id])
    else
      whoops
    end
  end

  def show
    @study_set = StudySet.find_by_id(params[:id])
    @flash_cards = @study_set.flash_cards
    @flash_card = FlashCard.new
    respond_to do |f|
      f.html { render :show }
      f.json { render json: @study_set }
    end
  end

  def edit
    if user_verified?
      @study_set = StudySet.find_by_id(params[:id])
      @flash_cards = @study_set.flash_cards
    else
      whoops
    end
  end

  def destroy
    if user_verified?
      study_set = StudySet.find_by_id(params[:id])
      study_set.destroy
      redirect_to user_path(current_user)
    else
      whoops
    end
  end

  def sort
    @study_set = StudySet.find_by_id(params[:id])
    @sort ||= params[:sort]
    @flash_card = FlashCard.new
    params[:user_id] = current_user.id if current_user
    if params[:sort] == "Alphabetical"
      @flash_cards = @study_set.flash_cards.sort_by {|fs| fs.term }
    else
      @flash_cards = @study_set.flash_cards
    end
    render :show
  end

  def copy
    @study_set = StudySet.find_by_id(params[:id])
    @study_set.make_copy(current_user)
    redirect_to user_path(current_user)
  end

  def study_mode
    @study_set = StudySet.find_by_id(params[:id])
    @study_set.add_studier(current_user)
    render json: @study_set
  end

  private

  def study_set_params
    params.require(:study_set).permit(:title, :description, :owner_id, :flash_cards_attributes => [:term, :definition, :_destroy, :id])
  end
end

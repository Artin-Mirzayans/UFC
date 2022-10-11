class FightersController < ApplicationController
  before_action :authorize_admin_or_mod!
  
  def index
    
  end
  
  def new
    @fighter = Fighter.new
  end

  def create
    @fighter = Fighter.new(fighter_params)

    if @fighter.save
      redirect_to fighters_path
    else
      render :new
    end
  end

  def show
    @fighter = Fighter.find(params[:fighter_id])
  end

  def update
    @fighter = Fighter.find(params[:fighter_id])
    if @fighter.update(fighter_params)
      redirect_to fighters_path
    else
      render :show
    end
  end

  def search
    if params[:name].present?
      @fighters = Fighter.where("name ilike ?", "%#{params[:name]}%").and(Fighter.where(active: true)).limit(10)
    end

    if params[:corner] == "red"
      @search_results_target = "search_results_#{params[:corner]}"
    elsif params[:corner] == "blue"
      @search_results_target = "search_results_#{params[:corner]}"
    else
      @search_results_target = "results"
    end

    respond_to { |format| format.turbo_stream }
  end

  def destroy
    @fighter = Fighter.find(params[:fighter_id])
    if @fighter.fights.count == 0
      @fighter.destroy
      redirect_to fighters_path
    else 
      render :show
    end
  end

  private
  
  def fighter_params
    params.require(:fighter).permit(:name, :active)
  end

end

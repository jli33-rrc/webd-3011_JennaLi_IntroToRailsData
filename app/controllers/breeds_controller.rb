class BreedsController < ApplicationController
  def index
    if params[:search].present?
      @breeds = Breed.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
                     .page(params[:page]).per(10)
    else
      @breeds = Breed.page(params[:page]).per(10)
    end
  end

  def show
    @breed = Breed.find(params[:id])
  end
end

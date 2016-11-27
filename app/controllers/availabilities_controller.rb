class AvailabilitiesController < ApplicationController
  before_action :availability, only: [:edit, :update, :destroy]
  before_action :products, only: [:new, :edit]

  def index
    @availabilities = Availability._all
  end

  def new
    @availability = {}
  end

  def create
    @availability = Availability.new(availability_params)
    if @availability.valid?
      Availability._create(availability_params.to_h, params[:id])
      redirect_to availabilities_path
    else
      render :new, notice: 'Availability created'
    end
  end

  def update
    @availability = Availability.new(availability_params)
    if @availability.valid?
      Availability._update(availability_params.to_h, params[:id])
      redirect_to availabilities_path
    else
      render :edit, notice: 'Availability updated'
    end
  end

  def destroy
    Availability._destroy(params[:id])
    redirect_to availabilities_path
  end

  private

  def availability_params
    params.require(:availability).permit(
      :product_id,
      :amount,
      :end_date,
      :price
    )
  end

  def availability
    @availability ||= Availability._find(params[:id])
  end

  def products
    @products ||= Product._all
  end
end

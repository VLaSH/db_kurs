class AvailabilitiesController < ApplicationController
  before_action :availability, only: [:edit, :update, :destroy]
  before_action :products, only: [:new, :edit]

  def new
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    if @availability.valid? && @availability.save
      redirect_to availabilities_path
    else
      render :new, notice: 'Availability created'
    end
  end

  def update
    if availability.update(availability_params)
      redirect_to availabilities_path
    else
      render :edit, notice: 'Availability updated'
    end
  end

  def destroy
    availability.destroy
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
    @availability ||= Availability.find(params[:id])
  end

  def products
    @products ||= Product._all
  end
end

class DeliveriesController < ApplicationController
  before_action :delivery, only: [:edit, :update, :destroy]
  before_action :providers, only: [:new, :edit]
  before_action :products, only: [:new, :edit]

  def index
    @deliveries = Delivery.all
  end

  def new
    @delivery = Delivery.new
  end

  def create
    @delivery = Delivery._create(delivery_params)
    redirect_to deliveries_path
  end

  def update
    if delivery.update(delivery_params)
      redirect_to deliveries_path
    else
      render :edit, notice: 'Delivery Updated'
    end
  end

  def destroy
    delivery.destroy
    redirect_to deliveries_path
  end

  private

  def delivery_params
    params.require(:delivery).permit(
      :provider_id,
      :product_id,
      :price,
      :amount,
      :delivery_date,
      :end_date
    ).to_hash
  end

  def delivery
    @delivery ||= Delivery.find(params[:id])
  end

  def providers
    @providers ||= Provider._all
  end

  def products
    @products ||= Product._all
  end
end

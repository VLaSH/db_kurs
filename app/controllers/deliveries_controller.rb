class DeliveriesController < ApplicationController
  before_action :delivery, only: [:edit, :update, :destroy]
  before_action :providers, only: [:new, :create, :edit, :update]
  before_action :products, only: [:new, :create, :edit, :update]

  def index
    @deliveries = Delivery._all
  end

  def new
    @delivery = Delivery.new
  end

  def create
    @delivery = Delivery.new(delivery_params)
    if @delivery.valid?
      Delivery._create(delivery_params.to_h)
      redirect_to deliveries_path
    else
      render :new, notice: 'Delivery created'
    end
  end

  def update
    @delivery = Delivery.new(delivery_params)
    if @delivery.valid?
      Delivery._update(delivery_params.to_h, params[:id])
      redirect_to deliveries_path
    else
      render :edit, notice: 'Delivery Updated'
    end
  end

  def destroy
    Delivery._destroy(params[:id])
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
    )
  end

  def delivery
    @delivery ||= Delivery._find(params[:id])
  end

  def providers
    @providers ||= Provider._all
  end

  def products
    @products ||= Product._all
  end
end

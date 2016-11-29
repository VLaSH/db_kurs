class DeliveriesController < ApplicationController
  before_action :delivery, only: [:edit, :update, :destroy, :show]
  before_action :providers, only: [:new, :create, :edit, :update]
  before_action :products, only: [:new, :create, :edit, :update]

  def index
    @deliveries = Delivery._all
  end

  def new
    respond_to do |f|
      f.html { @delivery = Delivery.new }
      f.js { calc_price }
    end
  end

  def create
    @delivery = Delivery.new(delivery_params)
    if @delivery.valid?
      Delivery._create(delivery_params.to_h)
      redirect_to deliveries_path
    else
      render :new, notice: 'Delivery created'
    end
  rescue ActiveRecord::StatementInvalid => e
    flash[:error] = e.cause.message
    render :new
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
      :amount,
      :delivery_date
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

  def calc_price
    @price = Product._find(params[:product_id])[:price].to_f
    if @price.present?
      @price *= params[:count].to_i
    else
      @price = 0
    end
  end
end

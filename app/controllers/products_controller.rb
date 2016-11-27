class ProductsController < ApplicationController
  before_action :product, only: [:edit, :update, :destroy]
  before_action :categories, only: [:new, :edit]

  def index
    @products = Product._all
  end

  def new
    @product = {}
  end

  def create
    @product = Product.new(product_params)
    if @product.valid?
      Product._create(product_params.to_h)
      redirect_to products_path
    else
      render :new, notice: 'Product created'
    end
  end

  def update
    @product = Product.new(product_params)
    if @product.valid?
      Product._update(product_params.to_h)
      redirect_to products_path
    else
      render :edit, notice: 'Product updated'
    end
  end

  def destroy
    Product._destroy(params[:id])
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :category_id
    )
  end

  def product
    @product ||= Product._find(params[:id])
  end

  def categories
    @categories ||= Category._all
  end
end

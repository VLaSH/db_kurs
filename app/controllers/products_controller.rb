class ProductsController < ApplicationController
  before_action :product, only: [:edit, :update, :destroy]

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.valid? && @product.save
      redirect_to products_path
    else
      render :new, notice: 'Product created'
    end
  end

  def update
    if product.update(product_params)
      redirect_to products_path
    else
      render :edit, notice: 'Product updated'
    end
  end

  def destroy
    product.destroy
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
    @product ||= Product.find(params[:id])
  end
end

class CategoriesController < ApplicationController
  before_action :category, only: [:edit, :update, :destroy]

  def index
    @categories = Category._all
  end

  def new
    @category = Product.new
  end

  def create
    @category = Category.new(category_params)
    if @category.valid?
      Category._create(category_params.to_h, params[:id])
      redirect_to categories_path
    else
      render :new, notice: 'Category created'
    end
  end

  def update
    @category = Category.new(category_params)
    if @category.valid?
      Category._update(category_params.to_h, params[:id])
      redirect_to categories_path
    else
      render :edit, notice: 'Category updated'
    end
  end

  def destroy
    Category._destroy(params[:id])
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(
      :name
    )
  end

  def category
    @category ||= Category._find(params[:id])
  end
end

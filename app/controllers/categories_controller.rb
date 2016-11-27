class CategoriesController < ApplicationController
  before_action :category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.valid? && @category.save
      redirect_to categories_path
    else
      render :new, notice: 'Category created'
    end
  end

  def update
    if category.update(category_params)
      redirect_to categories_path
    else
      render :edit, notice: 'Category updated'
    end
  end

  def destroy
    category.destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(
      :name
    )
  end

  def category
    @category ||= Category.find(params[:id])
  end
end

class ProvidersController < ApplicationController
  before_action :provider, only: [:edit, :update, :destroy]

  def index
    @providers = Provider.all
  end

  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(provider_params)
    if @provider.valid? && @provider.save
      redirect_to providers_path
    else
      render :new, notice: 'Provider created'
    end
  end

  def update
    if provider.update(provider_params)
      redirect_to providers_path
    else
      render :edit, notice: 'Provider updated'
    end
  end

  def destroy
    provider.destroy
    redirect_to providers_path
  end

  private

  def provider_params
    params.require(:provider).permit(
      :address,
      :phone
    )
  end

  def provider
    @provider ||= Provider.find(params[:id])
  end
end

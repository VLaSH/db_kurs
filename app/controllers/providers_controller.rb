class ProvidersController < ApplicationController
  before_action :provider, only: [:edit, :update, :destroy]

  def index
    @providers = Provider._all
  end

  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(provider_params)
    if @provider.valid?
      Provider._create(provider_params.to_h)
      redirect_to providers_path
    else
      render :new, notice: 'Provider created'
    end
  end

  def update
    @provider = Provider.new(provider_params)
    if @provider.valid?
      Provider._update(provider_params.to_h, params[:id])
      redirect_to providers_path
    else
      render :edit, notice: 'Provider updated'
    end
  end

  def destroy
    Provider._destroy(params[:id])
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
    @provider ||= Provider._find(params[:id])
  end
end

class AvailabilitiesController < ApplicationController
  before_action :availability, only: [:destroy, :show]

  def index
    @availabilities = Availability._all
  end

  def destroy
    Availability._destroy(params[:id])
    redirect_to availabilities_path
  end

  private

  def availability
    @availability ||= Availability.new(Availability._find(params[:id]))
  end
end

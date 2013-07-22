class Maintain::MeasurementsController < ApplicationController
  def index
  	@measurements = Measurement.order(" measurement asc, unit_count asc ")
  end


  def new
  	@measurement = Measurement.new
  end

  def create
  	@measurement = Measurement.new(params[:measurement])
  	if @measurement.save
  		redirect_to maintain_measurements_path
  	else
  		render :new
  	end
  end

  def edit
  	@measurement = Measurement.find(params[:id])
  	@measurement_settings = Lookup.where(:category => 'measurement_category')

  end

  def update
  	@measurement = Measurement.find(params[:id])
  	if @measurement.update_attributes(params[:measurement])
  		redirect_to maintain_measurements_path
  	else
  		@measurement_settings = Lookup.where(:category => 'measurement_category').map{|lookup| [lookup.description, lookup.code]}
  		render :edit
  	end
  end

  def destroy
  	@measurement = Measurement.find(params[:id])
  	if @measurement.destroy
  		redirect_to maintain_measurements_path
  	else
  		redirect_to :back
  	end
  end
end

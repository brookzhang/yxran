class Maintain::HistoriesController < ApplicationController
  def index
    @histories = History.where(" stock_id =? ", params[:stock_id])
  end

  def show
  end
end

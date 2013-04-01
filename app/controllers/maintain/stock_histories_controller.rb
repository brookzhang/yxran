class Maintain::StockHistoriesController < ApplicationController
  def index
    @histories = StockHistory.where(" stock_id =? ", params[:stock_id])
  end

  def show
  end
end

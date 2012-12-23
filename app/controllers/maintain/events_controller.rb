class Maintain::EventsController < ApplicationController
  def index
    @events = Event.all
  end
  
end

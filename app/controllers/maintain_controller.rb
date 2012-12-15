class MaintainController < ApplicationController
  #before_filter :authorize!
  skip_authorization_check
  def index
  end
end

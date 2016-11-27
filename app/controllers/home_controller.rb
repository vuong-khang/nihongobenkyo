class HomeController < ApplicationController
  def index
  	@page = get_page()
  end
end

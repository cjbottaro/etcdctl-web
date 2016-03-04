class ImportsController < ApplicationController

  def new
  end

  def create
    Import.new(params[:file], params[:root]).save
    redirect_to keys_path
  end

end

class KeysController < ApplicationController

  def index
    @node = Node.find(params[:key], recursive: !!session[:recursive_dirs])
  end

end

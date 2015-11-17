class NodesController < ApplicationController
  respond_to :html

  def new
    @node = Node.new(key: params[:parent] + "/")
  end

  def create
    @node = Node.new(params[:node])
    @node.dir = params[:node][:dir] == "1"
    @node.save
    respond_with(@node, location: key_path(@node.parent_key))
  end

  def edit
    @node = Node.find(params[:id])
  end

  def update
    @node = Node.find(params[:id])
    @node.value = params[:node][:value]
    @node.save
    respond_with(@node, location: key_path(@node.key))
  end

  def confirm_destroy
    @node = Node.find(params[:id])
  end

  def destroy
    @node = Node.find(params[:id])
    @node.destroy
    respond_with(@node, location: key_path(@node.parent_key), action: :confirm_destroy)
  end

end

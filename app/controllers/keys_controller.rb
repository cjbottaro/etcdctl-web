class KeysController < ApplicationController

  def index
    respond_to do |format|

      format.html do
        @node = Node.find(params[:key], recursive: !!session[:recursive_dirs])
      end

      format.yaml do
        yaml = Etcd::Utils.load(root: key, cast_values: true).to_yaml
        send_data(yaml, type: "text/yaml", disposition: 'attachment', filename: "keys_#{Time.now.to_i}.yaml")
      end

      format.json do
        json = JSON.pretty_generate(Etcd::Utils.load(root: key, cast_values: true))
        send_data(json, type: "text/json", disposition: 'attachment', filename: "keys_#{Time.now.to_i}.json")
      end

    end
  end

private

  def key
    @key ||= begin
      if params[:key].blank?
        "/"
      elsif params[:key].starts_with?("/")
        param[:key]
      else
        "/" + params[:key]
      end
    end
  end

end

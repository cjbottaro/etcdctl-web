class KeysController < ApplicationController

  def index
    @node = Node.find(params[:key], recursive: !!session[:recursive_dirs])
    respond_to do |format|
      format.html
      format.yaml {
        send_data(Node.data_for_export(params["key"]).to_yaml, type: "text/yaml",
            disposition: 'attachment', filename: "keys_#{Time.now.to_i}.yaml")
      }
      format.json {
        send_data(Node.data_for_export(params["key"]).to_json, type: "text/json", disposition: 'inline')
      }
    end
  end

end

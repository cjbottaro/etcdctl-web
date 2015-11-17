class BrowserController < ApplicationController

  def browse
    begin
      response = RestClient.get("http://#{Etcdctl.host}/v2/keys/#{params[:key]}")
      result = JSON.parse(response.body)
    rescue RestClient::ResourceNotFound => e
      result = {}
    end
    @nodes = flatten_result(result)
  end

private

  def flatten_result(result)
    flat_result = []
    queue = [result["node"]]

    while !queue.empty?
      node = queue.pop
      if node["dir"]
        flat_result << { key: node["key"], dir: true }
        node["nodes"].each{ |next_node| queue << next_node }
      else
        flat_result << { key: node["key"], value: node["value"] }
      end
    end

    flat_result.sort_by{ |result| result[:key] }
  end

end

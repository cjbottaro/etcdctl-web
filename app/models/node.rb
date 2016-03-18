class Node
  include ActiveModel::Model

  extend ActiveModel::Callbacks
  define_model_callbacks :save

  attr_accessor :key, :dir, :value, :nodes

  before_save :normalize_key

  def self.find(key, options = {})
    response = response(key, options)
    load(response)

  rescue RestClient::ResourceNotFound => e
    nil
  end

  def self.response(key, options = {})
    options = options.reverse_merge recursive: false

    key = key.to_s.strip.sub(/^\//, "")
    key = Rack::Utils.escape_path(key)

    url = "http://#{Etcdctl.host}/v2/keys/#{key}"
    url += "?recursive=true" if options[:recursive]

    response = RestClient.get(url)
    result = JSON.parse(response.body)["node"]
  end

  def self.load(data)
    node = new key: data["key"] || "/",
               dir: !!data["dir"],
               value: data["value"]

    node.instance_variable_set(:@persisted, true)

    node.nodes = data["nodes"].map{ |child| load(child) } if node.dir? && data["nodes"].present?

    node
  end

  def self.data_for_export(key)
    response = response(key, {recursive: true})
    format_data_for_export(response)
  end

  def self.format_data_for_export(data, formatted_data = {})
    child_data = {}

    key   = if data.has_key?("key")
        data["key"].strip.split("/").last
      else
        nil
      end
    value = if data.has_key?("nodes")
        data["nodes"].each {|node| format_data_for_export(node, child_data)}
        child_data
      else
        data["value"]
      end

    if key
      formatted_data[key] = value
    else
      formatted_data = value
    end

    formatted_data
  end

  def id
    key
  end

  def persisted?
    !!@persisted
  end

  def dir?
    !!dir
  end

  def nodes
    @nodes ||= []
  end

  def flatten
    nodes = []
    queue = []

    queue << self
    while !queue.empty?
      current = queue.pop
      nodes << current
      current.nodes.each{ |node| queue << node }
    end

    nodes.sort_by(&:key)
  end

  def normalize_key
    self.key = key.gsub(/\/+/, "/")
  end

  def parent_key
    if key == "/"
      key
    else
      key.split("/").tap(&:pop).join("/")
    end
  end

  def save
    run_callbacks :save do
      if dir?
        data = { dir: true }
      else
        data = { value: value }
      end

      begin
        key = Rack::Utils.escape_path(self.key)
        RestClient.put("http://#{Etcdctl.host}/v2/keys#{key}", data)
      rescue RestClient::Exception => e
        errors.add(:base, e.response)
      end
    end
  end

  def destroy
    begin
      key = Rack::Utils.escape_path(self.key)
      RestClient.delete("http://#{Etcdctl.host}/v2/keys#{key}", params: { dir: "true", recursive: "true" })
    rescue RestClient::Exception => e
      errors.add(:base, e.response)
    end
  end

end

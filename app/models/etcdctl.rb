class Etcdctl

  if ENV["ETCD_HOST"]
    @config = { "hosts" => [ENV["ETCD_HOST"]] }
  else
    @config = YAML.load_file("#{Rails.root}/config/etcd.yml")
  end

  def self.host
    @config["hosts"].sample
  end

end

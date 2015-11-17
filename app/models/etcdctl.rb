class Etcdctl

  @config = YAML.load_file("#{Rails.root}/config/etcd.yml")

  def self.host
    @config["hosts"].sample
  end

end

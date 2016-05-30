class Import

  def initialize(file, root = "/")
    @file = file
    @root = root
    @root = "/" + @root unless @root.starts_with?("/")
  end

  def save
    Etcd::Utils.dump(hash, root: @root)
  end

  def hash
    @hash ||= YAML.load(@file.read)
  end

end

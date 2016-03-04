class Import

  def initialize(file, root = "/")
    @file = file
    @root = root
    @root = "/" + @root unless @root.starts_with?("/")
  end

  def save
    keys_and_values.each do |(key, value)|
      Node.new(key: "#{@root}/#{key}", value: value).save
      # puts Node.new(key: "#{@root}/#{key}", value: value).key
    end
  end

  def keys_and_values
    @keys_and_values ||= begin
      results = []
      stack = hash.to_a

      while !stack.empty?
        key, value = stack.pop
        case value
        when Hash
          value.each{ |k, v| stack << ["#{key}/#{k}", v] }
        when Array
          padding = 1 + value.length.to_s.length
          value.each_with_index{ |v, i| stack << ["#{key}/%0#{padding}d" % i, v] }
        else
          results << [key, value]
        end
      end

      results
    end
  end

  def hash
    @hash ||= YAML.load(@file.read)
  end

end

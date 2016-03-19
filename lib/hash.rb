
  class Hash
    def value_in_array(key, value)
      self.key?(key) ? self[key] << value : self[key] = [value]
    end
  end

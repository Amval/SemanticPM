# Extensions for the Hash base class.
class Hash
  # Creates an entry on the hash. Values are stored as an array.
  # Example:
  # {}.value_in_array('example', 1)
  # => {:example => [1]}
  # {}.value_in_array('example', 2)
  # => {:example => [1, 2]}
  def value_in_array(key, value)
    self.key?(key) ? self[key] << value : self[key] = [value]
  end

  # If the value for a given key is an Integer, increases it by one.
  # Example:
  # {a: 0, b: 1}.inc_value(:b)
  # => {a: 0, b: 2}
  def inc_value(key)
    value = self[key]
    self[key] = value.next if value.is_a? Integer
  end

  # If the values are all of the same type, confirms if a value is min for
  # a given key
  # Example:
  # {a: 1, b: 4, c: 0, d: 0}.value_is_min? :a
  # => false
  def value_is_min?(key)
    min = self.key(self.values.min)
    self[key] == self[min]
  end
end

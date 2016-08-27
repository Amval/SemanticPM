a = ["a","b","c"]

def pretty_print(resources)
  resources.map { |item| "<#{item}>"}
  resources.to_sentence
end

p pretty_print(a)

chosen_counter = {0=>3, 1=>1, 2=>4, 3=>2}
limit = 3
def selection_is_ok?
  chosen_counter = {0=>3, 1=>1, 2=>4, 3=>2}
  limit = 3

  !chosen_counter.values.any? { |v| v == 0 || v > limit}
end

p selection_is_ok?

{status, file} = File.read("day_1/input.txt")

string_to_num = fn(string) ->
  case string do
    "one" ->
      "1"
    "two" ->
      "2"
    "three" ->
      "3"
    "four" ->
      "4"
    "five" ->
      "5"
    "six" ->
      "6"
    "seven" ->
      "7"
    "eight" ->
      "8"
    "nine" ->
      "9"
  end
end

convert_first_last_num = fn(val) ->
  indexes = Enum.map(["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"], fn num ->
    index = :binary.match(val, num)
    if index == :nomatch do nil else {elem(index, 0), num} end
  end)
  no_nil = Enum.filter(indexes, & !is_nil(&1))
  unless Enum.empty?(no_nil) do
    min_index_match = Enum.min(no_nil)
    max_index_match = Enum.max(no_nil)
    first_part = elem(String.split_at(val, elem(min_index_match, 0)+1), 0)
    second_part = elem(String.split_at(val, elem(min_index_match, 0)+String.length(elem(min_index_match, 1))-1), 1)
    new_string = first_part <> string_to_num.(elem(min_index_match, 1)) <> second_part
    unless elem(min_index_match, 0) == elem(max_index_match, 0) do
      new_max_index = elem(max_index_match, 0) - String.length(elem(min_index_match, 1)) + 4
      first_part = elem(String.split_at(new_string, new_max_index), 0)
      second_part = elem(String.split_at(new_string, new_max_index+String.length(elem(max_index_match, 1))-2), 1)
      new_string_2 = first_part <> string_to_num.(elem(max_index_match, 1)) <> second_part
      IO.puts(new_string <> " -> " <> new_string_2)
      new_string_2
    else
      new_string
    end
  else
    val
  end
end

array_file = String.split(file, "\n")

array_converted = Enum.map(array_file, fn val ->
  convert_first_last_num.(val)
end)

array_converted1 = Enum.map(array_converted, fn val ->
  convert_first_last_num.(val)
end)

array_converted2 = Enum.map(array_converted1, fn val ->
  convert_first_last_num.(val)
end)

array_converted3 = Enum.map(array_converted2, fn val ->
  convert_first_last_num.(val)
end)

array_converted4 = Enum.map(array_converted3, fn val ->
  convert_first_last_num.(val)
end)

Enum.map(array_converted, fn val ->
  IO.puts(val)
end)

array_nums = Enum.map(array_converted4, fn val ->
  Enum.filter(String.graphemes(val), fn char ->
    num = Integer.parse(char)
    num != :error
  end)
end)

array_values = Enum.map(array_nums, fn val ->
  if val == [] do
    0
  else
    elem(Integer.parse(List.first(val) <> List.last(val)), 0)
  end
end)

Enum.map(Enum.with_index(array_values), fn val ->
  IO.puts(Integer.to_string(elem(val, 0)) <> " " <> Enum.at(array_file, elem(val, 1)))
end)


IO.puts(Enum.sum(array_values))

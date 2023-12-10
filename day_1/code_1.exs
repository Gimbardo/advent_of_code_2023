file = elem(File.read("day_1/input.txt"), 1)

array_file = String.split(file, "\n")

array_nums = Enum.map(array_file, fn val ->
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

IO.puts(Enum.sum(array_values))

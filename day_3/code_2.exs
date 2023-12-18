defmodule Day3 do

  @gear "*"
  @right 1
  @left 0
  @empty_value 0

  def string_from_index_find_num(string, index) do
    if index == -1 do
      @empty_value
    else
      elem(Integer.parse(String.slice(string, limit_num_index(string, index, @left)..limit_num_index(string, index, @right))), 0)
    end
  end

  def string_from_indexes_find_nums(string, indexes) do
    Enum.map(indexes, fn index ->
      string_from_index_find_num(string, index)
    end)
  end

  def limit_num_index(string, index, direction) do
    parsed_num = Integer.parse(String.at(string, index))
    new_index = if direction == @right, do: index + 1, else: index - 1
    index_before_this = if direction == @right, do: index - 1, else: index + 1
    if parsed_num != :error, do: limit_num_index(string, new_index, direction), else: index_before_this
  end

  def read_file() do
    file = elem(File.read("day_3/input.txt"), 1)
    String.split(file, "\n")
  end

  def nums_in_string_index(string, offset) do
    scan = Regex.scan(~r/\d+/, string, return: :index)
    if Enum.empty?(scan), do: [-1], else: Enum.map(scan, fn val ->
      elem(Enum.fetch!(val, 0), 0) + offset
    end)
  end

  def char_is_num?(char) do
    Integer.parse(char) != :error
  end

  def delete_every_val(enum, val) do
    Enum.filter(enum, fn elem ->
      elem != val
    end)
  end

  def multiply_if_exactly_2(values) do
    list_filtered = delete_every_val(values, @empty_value)
    # i dont need to check if there is a 0 (@empty_value), because in that case the multiplication would result to 0 anyway
    if length(list_filtered) == 2 do
      Enum.fetch!(list_filtered, 0) * Enum.fetch!(list_filtered, 1)
    else
      0
    end
  end

  def add_multiplied_gears() do
    array_file = read_file()
    line_sums = Enum.map(Enum.with_index(array_file), fn line ->
      line_index = elem(line, 1)
      line_string = elem(line, 0)
      gear_indexes = Regex.scan(~r/#{'\\'}#{@gear}+/, line_string, return: :index)

      line_gear_ratios = Enum.map(gear_indexes, fn gear_index ->
        gear_index = elem(Enum.fetch!(gear_index, 0), 0)
        upper_line = Enum.fetch!(array_file, line_index - 1)
        upper_around_gear = String.slice(upper_line, (gear_index-1)..(gear_index+1))
        upper_line_num_indexes = nums_in_string_index(upper_around_gear, gear_index-1)

        lower_line = Enum.fetch!(array_file, line_index + 1)
        lower_around_gear = String.slice(lower_line, (gear_index-1)..(gear_index+1))
        lower_line_num_indexes = nums_in_string_index(lower_around_gear, gear_index-1)

        right_line_num_indexes = if char_is_num?(String.at(line_string, gear_index+1)), do: [gear_index+1], else: [-1]
        left_line_num_indexes = if char_is_num?(String.at(line_string, gear_index-1)), do: [gear_index-1], else: [-1]

        upper_num = string_from_indexes_find_nums(upper_line, upper_line_num_indexes)
        lower_num = string_from_indexes_find_nums(lower_line, lower_line_num_indexes)
        right_num = string_from_indexes_find_nums(line_string, right_line_num_indexes)
        left_num = string_from_indexes_find_nums(line_string, left_line_num_indexes)

        multiply_if_exactly_2(upper_num ++ lower_num ++ right_num ++ left_num)
      end)
      Enum.sum(line_gear_ratios)
    end)
    Enum.sum(line_sums)
  end

end

IO.inspect Day3.add_multiplied_gears()

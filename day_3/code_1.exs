defmodule Day3 do

  @neutral_char "."

  def read_file() do
    file = elem(File.read("day_3/input.txt"), 1)
    String.split(file, "\n")
  end

  def contains_only_char?(string, char) do
    String.length(String.replace(string, char, "")) == 0
  end

  def contains_only_char_in_range?(string, char, start_index, end_index) do
    contains_only_char?(String.slice(string, start_index..end_index), char)
  end

  def embed_string(string) do
    @neutral_char <> string <> @neutral_char
  end

  def add_valids() do
    array_file = read_file()

    line_sums = Enum.map(Enum.with_index(array_file), fn line ->
      line_index = elem(line, 1)
      line_string = elem(line, 0)
      nums_index = Regex.scan(~r/\d+/, line_string, return: :index)
      valid_nums_in_line = Enum.map(nums_index, fn start_end_index_array ->
        start_length_index = Enum.fetch!(start_end_index_array, 0)
        start_index = elem(start_length_index, 0)
        length_num = elem(start_length_index, 1)
        num = String.slice(line_string, start_index..start_index+length_num-1)

        upper_only_dot? = unless line_index == 0 do
          upper_line = embed_string(Enum.fetch!(array_file, line_index - 1))
          contains_only_char_in_range?(upper_line, @neutral_char, start_index, start_index+length_num+1)
        else
          true
        end
        lower_only_dot? = unless line_index == length(array_file)-1 do
          lower_line = embed_string(Enum.fetch!(array_file, line_index + 1))
          contains_only_char_in_range?(lower_line, @neutral_char, start_index, start_index+length_num+1)
        else
          true
        end
        embedded_line = embed_string(line_string)
        left_dot? = ( String.at(embedded_line, start_index) == @neutral_char)
        right_dot? = ( String.at(embedded_line, start_index+length_num + 1) == @neutral_char )
        if left_dot? && right_dot? && upper_only_dot? && lower_only_dot? do
          0
        else
          elem(Integer.parse(num), 0)
        end
      end)
      Enum.sum(valid_nums_in_line)
    end)
    Enum.sum(line_sums)
  end

end

IO.puts Day3.add_valids()

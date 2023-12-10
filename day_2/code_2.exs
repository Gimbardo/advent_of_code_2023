defmodule Day2 do

  def sum_min_values_moltiplied() do
    file = elem(File.read("day_2/input.txt"), 1)
    array_file = String.split(file, "\n")

    id_games = Enum.map(array_file, fn val ->
      String.split(Regex.replace(~r/\s/u, val, ""), ":")
    end)

    powers = Enum.map(id_games, fn game ->
      rolls = String.split(List.last(game), ";")
      formatted_game = Enum.map(rolls, fn roll ->
        extractions = String.split(roll, ",")
        extractions_values = Enum.map(extractions, fn extraction ->
          extraction_to_value(extraction)
        end)
        formatted = Enum.map([0, 1, 2], fn index ->
          Enum.max(Enum.map(extractions_values, fn extraction ->
            Enum.at(extraction, index)
          end))
        end)
        formatted
      end)

      max_values = Enum.map([0, 1, 2], fn index ->
        Enum.max(Enum.map(formatted_game, fn extraction ->
          Enum.at(extraction, index)
        end))
      end)
      Enum.reduce(max_values, fn val, acc -> val * acc end)

    end)
    Enum.sum(powers)
  end

  # [ red, green, blue ]
  def extraction_to_value(extraction) do
    cond do
      String.contains?(extraction, "red") ->
        [elem(Integer.parse(String.replace(extraction, "red", "")), 0), 0, 0]
      String.contains?(extraction, "green") ->
        [0, elem(Integer.parse(String.replace(extraction, "green", "")), 0), 0]
      String.contains?(extraction, "blue") ->
        [0, 0, elem(Integer.parse(String.replace(extraction, "blue", "")), 0)]
    end
  end

end

IO.puts(Day2.sum_min_values_moltiplied())

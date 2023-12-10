defmodule Day2 do

  def sum_valid_ids() do
    file = elem(File.read("day_2/input.txt"), 1)
    array_file = String.split(file, "\n")

    id_games = Enum.map(array_file, fn val ->
      String.split(Regex.replace(~r/\s/u, val, ""), ":")
    end)

    id_valid_arrays = Enum.map(id_games, fn game ->
      game_id = Integer.parse(List.last(String.split(List.first(game), "Game")))

      rolls = String.split(List.last(game), ";")
      game_validity = Enum.map(rolls, fn roll ->
        extractions = String.split(roll, ",")
        extractions_validity = Enum.map(extractions, fn extraction ->
          extraction_to_validity(extraction)
        end)
        not Enum.member?(extractions_validity, false)
      end)

      if Enum.member?(game_validity, false), do: 0, else: elem(game_id ,0)
    end)

    Enum.sum(id_valid_arrays)
  end

  def extraction_to_validity(extraction) do
    cond do
      String.contains?(extraction, "red") ->
        elem(Integer.parse(String.replace(extraction, "red", "")), 0) <= 12
      String.contains?(extraction, "green") ->
        elem(Integer.parse(String.replace(extraction, "green", "")), 0) <= 13
      String.contains?(extraction, "blue") ->
        elem(Integer.parse(String.replace(extraction, "blue", "")), 0) <= 14
    end
  end

end

IO.puts(Day2.sum_valid_ids())

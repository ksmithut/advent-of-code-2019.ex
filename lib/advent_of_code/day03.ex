defmodule AdventOfCode.Day03 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day03.part1("R8,U5,L5,D3\nU7,R6,D4,L4")
      6

      iex> AdventOfCode.Day03.part1("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
      159

      iex> AdventOfCode.Day03.part1("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
      135

      iex> AdventOfCode.Day03.part2("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
      610

      iex> AdventOfCode.Day03.part2("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
      410

  """
  def part1(input) do
    parse_input(input)
    |> Enum.map(&run_wire/1)
    |> find_closest_intersection()
  end

  def part2(input) do
    parse_input(input)
    |> Enum.map(&run_wire/1)
    |> find_soonest_intersection()
  end

  defp parse_input(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(fn
        "R" <> num -> {:right, String.to_integer(num)}
        "D" <> num -> {:down, String.to_integer(num)}
        "U" <> num -> {:up, String.to_integer(num)}
        "L" <> num -> {:left, String.to_integer(num)}
      end)
    end)
  end

  defp run_wire(instructions, grid \\ %{}, pointer \\ {0, 0}, count \\ 1)
  defp run_wire([], grid, _, _), do: grid

  defp run_wire([{direction, amount} | instructions], grid, pointer, count) do
    {grid, pointer, count} = run_direction(amount, direction, grid, pointer, count)
    run_wire(instructions, grid, pointer, count)
  end

  defp run_direction(0, _, grid, pointer, count), do: {grid, pointer, count}

  defp run_direction(amount, direction, grid, {x, y}, count) do
    pointer =
      case direction do
        :right -> {x + 1, y}
        :down -> {x, y - 1}
        :left -> {x - 1, y}
        :up -> {x, y + 1}
      end

    value = Map.get(grid, pointer, count)

    run_direction(amount - 1, direction, Map.put(grid, pointer, value), pointer, count + 1)
  end

  defp find_closest_intersection([grid1, grid2]) do
    MapSet.intersection(map_keys(grid1), map_keys(grid2))
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min()
  end

  defp find_soonest_intersection([grid1, grid2]) do
    MapSet.intersection(map_keys(grid1), map_keys(grid2))
    |> Enum.map(fn point -> Map.get(grid1, point) + Map.get(grid2, point) end)
    |> Enum.min()
  end

  defp map_keys(map), do: Map.keys(map) |> MapSet.new()
end

defmodule AdventOfCode.Day10 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day10.part1(".#..#\n.....\n#####\n....#\n...##")
      8

      iex> AdventOfCode.Day10.part1("......#.#.\n#..#.#....\n..#######.\n.#.#.###..\n.#..#.....\n..#....#.#\n#..#....#.\n.##.#..###\n##...#..#.\n.#....####")
      33

      iex> AdventOfCode.Day10.part1("#.#...#.#.\n.###....#.\n.#....#...\n##.#.#.#.#\n....#.#.#.\n.##..###.#\n..#...##..\n..##....##\n......#...\n.####.###.")
      35

      iex> AdventOfCode.Day10.part1(".#..#..###\n####.###.#\n....###.#.\n..###.##.#\n##.##.#.#.\n....###..#\n..#.#..#.#\n#..#.#.###\n.##...##.#\n.....#.#..")
      41

      iex> AdventOfCode.Day10.part1(".#..##.###...#######\n##.############..##.\n.#.######.########.#\n.###.#######.####.#.\n#####.##.#.##.###.##\n..#####..#.#########\n####################\n#.####....###.#.#.##\n##.#################\n#####.##.###..####..\n..######..##.#######\n####.##.####...##..#\n.#####..#.######.###\n##...#.##########...\n#.##########.#######\n.####.#.###.###.#.##\n....##.##.###..#####\n.#.#.###########.###\n#.#.#.#####.####.###\n###.##.####.##.#..##")
      210

      iex> AdventOfCode.Day10.part2(".#..##.###...#######\n##.############..##.\n.#.######.########.#\n.###.#######.####.#.\n#####.##.#.##.###.##\n..#####..#.#########\n####################\n#.####....###.#.#.##\n##.#################\n#####.##.###..####..\n..######..##.#######\n####.##.####...##..#\n.#####..#.######.###\n##...#.##########...\n#.##########.#######\n.####.#.###.###.#.##\n....##.##.###..#####\n.#.#.###########.###\n#.#.#.#####.####.###\n###.##.####.##.#..##")
      802

  """
  def part1(input) do
    parse(input)
    |> find_asteroids()
    |> find_monitoring_position()
    |> (fn {_, visible_asteroids} -> visible_asteroids end).()
  end

  def part2(input) do
    asteroids = parse(input) |> find_asteroids()

    find_monitoring_position(asteroids)
    |> blast_asteroids(asteroids)
    |> Enum.at(199)
    |> (fn {{x, y}, _} -> x * 100 + y end).()
  end

  defp parse(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, map ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {value, x}, map -> Map.put(map, {x, y}, value) end)
    end)
  end

  defp find_monitoring_position(asteroids) do
    asteroids
    |> Enum.map(&evaluate_asteroid(&1, asteroids))
    |> Enum.max_by(fn {_, visible_asteroids} -> visible_asteroids end)
  end

  defp find_asteroids(map) do
    Enum.filter(map, fn {_, value} -> value == "#" end)
    |> Enum.map(fn {pos, _} -> pos end)
  end

  defp evaluate_asteroid(from, asteroids) do
    asteroids
    |> List.delete(from)
    |> Enum.map(&degrees(from, &1))
    |> Enum.reduce(MapSet.new(), fn degrees, set -> MapSet.put(set, degrees) end)
    |> MapSet.size()
    |> (&{from, &1}).()
  end

  defp degrees({aX, aY}, {bX, bY}) do
    :math.atan2(bX - aX, bY - aY) + :math.pi()
  end

  defp blast_asteroids({from, _}, asteroids) do
    asteroids
    |> List.delete(from)
    |> Enum.reduce(%{}, fn asteroid, map ->
      key = degrees(from, asteroid)

      Map.get(map, key, [])
      |> Kernel.++([{asteroid, distance(from, asteroid)}])
      |> Enum.sort_by(fn {_, distance} -> distance end)
      |> (&Map.put(map, key, &1)).()
    end)
    |> destroy_order()
  end

  defp destroy_order(asteroid_map, destroyed \\ []) do
    Map.keys(asteroid_map)
    |> Enum.sort(&(&1 > &2))
    |> Enum.reduce({%{}, destroyed}, fn key, {new_map, destroyed} ->
      [to_destroy | rest] = Map.get(asteroid_map, key)
      new_destroyed = destroyed ++ [to_destroy]

      case rest do
        [] -> {new_map, new_destroyed}
        rest -> {Map.put(new_map, key, rest), new_destroyed}
      end
    end)
    |> (fn
          {%{}, destroyed} -> destroyed
          {map, destroyed} -> destroy_order(map, destroyed)
        end).()
  end

  defp distance({aX, aY}, {bX, bY}) do
    (:math.pow(aX - bX, 2) + :math.pow(aY - bY, 2))
    |> :math.sqrt()
  end
end

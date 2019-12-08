defmodule AdventOfCode.Day06 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day06.part1("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L")
      42

      iex> AdventOfCode.Day06.part2("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN")
      4


  """
  def part1(input) do
    parse_input(input)
    |> build_orbit_tree()
    |> count_orbits()
  end

  def part2(input) do
    parse_input(input)
    |> build_orbit_tree()
    |> path_length("YOU", "SAN")
  end

  defp parse_input(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ")"))
  end

  defp build_orbit_tree(definition, root \\ "COM") do
    branches =
      definition
      |> Enum.filter(fn
        [^root, _] -> true
        _ -> false
      end)
      |> Enum.map(fn [_, value] -> build_orbit_tree(definition, value) end)

    {root, branches}
  end

  defp count_orbits({_, branches}, depth \\ 1) do
    length(branches) * depth +
      (branches
       |> Enum.map(&count_orbits(&1, depth + 1))
       |> Enum.sum())
  end

  defp path_length(root, from, to) do
    paths = all_paths(root)
    from_path = Enum.find(paths, fn path -> List.last(path) == from end)
    to_path = Enum.find(paths, fn path -> List.last(path) == to end)

    diff = List.myers_difference(from_path, to_path)
    length(diff[:del]) + length(diff[:ins]) - 2
  end

  defp all_paths({root, branches}, prev \\ []) do
    path = prev ++ [root]
    sub_paths = branches |> Enum.map(&all_paths(&1, path)) |> Enum.concat()
    [path | sub_paths]
  end
end

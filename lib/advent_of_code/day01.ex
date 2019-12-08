defmodule AdventOfCode.Day01 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day01.part1("12")
      2

      iex> AdventOfCode.Day01.part1("14")
      2

      iex> AdventOfCode.Day01.part1("1969")
      654

      iex> AdventOfCode.Day01.part1("100756")
      33583

      iex> AdventOfCode.Day01.part2("14")
      2

      iex> AdventOfCode.Day01.part2("1969")
      966

      iex> AdventOfCode.Day01.part2("100756")
      50346

  """

  def part1(input) do
    parse(input)
    |> Stream.map(&fuel_required/1)
    |> Enum.sum()
  end

  def part2(input) do
    parse(input)
    |> Stream.map(&total_fuel_required/1)
    |> Enum.sum()
  end

  defp parse(input) do
    String.trim(input)
    |> String.split("\n")
    |> Stream.map(&String.to_integer/1)
  end

  defp fuel_required(mass) do
    Integer.floor_div(mass, 3)
    |> Kernel.-(2)
    |> (fn num -> Enum.max([num, 0]) end).()
  end

  defp total_fuel_required(0), do: 0

  defp total_fuel_required(mass) do
    fuel = fuel_required(mass)
    fuel + total_fuel_required(fuel)
  end
end

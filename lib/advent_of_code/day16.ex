defmodule AdventOfCode.Day16 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day16.part1("12345678", 1)
      "48226158"

      iex> AdventOfCode.Day16.part1("12345678", 2)
      "34040438"

      iex> AdventOfCode.Day16.part1("12345678", 3)
      "03415518"

      iex> AdventOfCode.Day16.part1("12345678", 4)
      "01029498"

      iex> AdventOfCode.Day16.part1("80871224585914546619083218645595")
      "24176176"

      iex> AdventOfCode.Day16.part1("19617804207202209144916044189917")
      "73745418"

      iex> AdventOfCode.Day16.part1("69317163492948606335995924319873")
      "52432133"



  """
  def part1(input, phases \\ 100) do
    String.trim(input)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> hash(phases)
    |> Enum.take(8)
    |> Enum.join()
  end

  def part2(input) do
    input
  end

  defp hash(list, 0), do: list

  defp hash(list, phases) do
    len = length(list)

    for spread <- 0..(len - 1) do
      list
      |> Stream.with_index()
      |> Stream.map(fn {digit, index} ->
        digit * pattern_value(index + 1, spread)
      end)
      |> Enum.sum()
      |> abs()
      |> Integer.digits()
      |> List.last()
    end
    |> hash(phases - 1)
  end

  def pattern_value(index, spread \\ 0) do
    spread = spread + 1
    num = div(index + 3 * spread, spread)
    abs(rem(num, 4) - 2) - 1
  end
end

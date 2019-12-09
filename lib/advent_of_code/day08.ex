defmodule AdventOfCode.Day08 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day08.part1("123456789012", width: 3, height: 2)
      1

      iex> AdventOfCode.Day08.part2("0222112222120000", width: 2, height: 2)
      "01\n10"

      iex> AdventOfCode.Day08.part2("222222222211111112000000000", width: 3, height: 3)
      "011\n111\n110"

  """
  def part1(input, opts \\ [width: 25, height: 6]) do
    parse(input, opts[:width], opts[:height])
    |> Enum.reduce(fn layer, fewest_zeros ->
      if count_equals(layer, "0") < count_equals(fewest_zeros, "0"),
        do: layer,
        else: fewest_zeros
    end)
    |> (fn layer -> count_equals(layer, "1") * count_equals(layer, "2") end).()
  end

  def part2(input, opts \\ [width: 25, height: 6]) do
    parse(input, opts[:width], opts[:height])
    |> (fn layers ->
          List.first(layers)
          |> Enum.with_index()
          |> Enum.map(fn {_, index} ->
            Enum.find(layers, fn layer -> Enum.at(layer, index) != "2" end) |> Enum.at(index)
          end)
        end).()
    |> Enum.chunk_every(opts[:width])
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  defp parse(input, width, height) do
    String.trim(input)
    |> String.graphemes()
    |> Enum.chunk_every(width * height)

    # |> Enum.map(fn layer -> Enum.chunk_every(layer, width) end)
  end

  defp equals?(a, b), do: a == b

  defp count_equals(enumerable, value), do: Enum.count(enumerable, &equals?(&1, value))
end

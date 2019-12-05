defmodule AdventOfCode.Day04 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day04.password?(111111)
      true

      iex> AdventOfCode.Day04.password?(223450)
      false

      iex> AdventOfCode.Day04.password?(123789)
      false

      iex> AdventOfCode.Day04.password2?(112233)
      true

      iex> AdventOfCode.Day04.password2?(123444)
      false

      iex> AdventOfCode.Day04.password2?(111122)
      true

  """
  def part1(input), do: parse_input(input) |> Enum.count(&password?/1)

  def part2(input), do: parse_input(input) |> Enum.count(&password2?/1)

  defp parse_input(input) do
    String.trim(input)
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    |> (fn [a, b] -> a..b end).()
  end

  def password?(num) do
    integer_length?(num, 6) && adjacent_digits?(num) && increasing_digits?(num)
  end

  def password2?(num) do
    integer_length?(num, 6) && double_digits?(num) && increasing_digits?(num)
  end

  defp integer_length?(num, match), do: Integer.digits(num) |> length() |> Kernel.==(match)

  defp adjacent_digits?(num) do
    Integer.digits(num)
    |> Enum.chunk_by(& &1)
    |> Enum.any?(fn chunk -> length(chunk) >= 2 end)
  end

  defp double_digits?(num) do
    Integer.digits(num)
    |> Enum.chunk_by(& &1)
    |> Enum.any?(fn chunk -> length(chunk) == 2 end)
  end

  defp increasing_digits?(num) do
    Integer.digits(num)
    |> Enum.sort()
    |> Enum.join()
    |> String.to_integer()
    |> Kernel.==(num)
  end
end

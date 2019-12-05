defmodule AdventOfCode do
  @moduledoc """
  Documentation for AdventOfCode.
  """

  def run(day, part \\ 1) do
    string_day = to_string(day) |> String.pad_leading(2, "0")
    module = String.to_atom("#{__MODULE__}.Day#{string_day}")
    input = File.read!("day#{string_day}.txt")

    case part do
      1 -> module.part1(input)
      2 -> module.part2(input)
      _ -> {:error, "No such part#{part}"}
    end
  end

  def generate(day) do
    string_day = to_string(day) |> String.pad_leading(2, "0")

    template = """
    defmodule AdventOfCode.Day#{string_day} do
      @doc \~S\"""
      ## Examples

          iex> AdventOfCode.Day#{string_day}.part1("hello")
          "hello"

          iex> AdventOfCode.Day#{string_day}.part2("hello")
          "hello"

      \"""
      def part1(input) do
        input
      end

      def part2(input) do
        input
      end
    end
    """

    filepath = Path.join([__DIR__, "advent_of_code", "day#{string_day}.ex"])

    with false <- File.exists?(filepath),
         :ok <- File.write!(filepath, template),
         :ok <- File.write!("day#{string_day}.txt", "") do
      IO.puts("Generated #{filepath}")
    else
      true -> IO.puts("File already exists at #{filepath}")
    end
  end
end

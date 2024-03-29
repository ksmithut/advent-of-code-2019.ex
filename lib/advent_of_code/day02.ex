defmodule AdventOfCode.Day02 do
  alias AdventOfCode.IntCode

  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day02.part1("1,0,0,0,99", noun: 0, verb: 0)
      2

      iex> AdventOfCode.Day02.part1("2,3,0,3,99", noun: 3, verb: 0)
      2

      iex> AdventOfCode.Day02.part1("2,4,4,5,99,0", noun: 4, verb: 4)
      2

      iex> AdventOfCode.Day02.part1("1,1,1,4,99,5,6,0,99", noun: 1, verb: 1)
      30

      iex> AdventOfCode.Day02.part1("1,9,10,3,2,3,11,0,99,30,40,50", noun: 9, verb: 10)
      3500

  """

  def part1(input, opts \\ [noun: 12, verb: 2]) do
    IntCode.parse_program(input)
    |> Map.put(1, opts[:noun])
    |> Map.put(2, opts[:verb])
    |> run_program()
  end

  def part2(input) do
    search_value = 19_690_720

    for(noun <- 0..99, verb <- 0..99, do: {noun, verb})
    |> Enum.find(fn {noun, verb} -> part1(input, noun: noun, verb: verb) === search_value end)
    |> (fn {noun, verb} -> 100 * noun + verb end).()
  end

  defp run_program(program) do
    pid = IntCode.run_program(program)

    receive do
      {:end_program, ^pid, state} -> Map.get(state, 0)
    end
  end
end

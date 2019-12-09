defmodule AdventOfCode.Day07 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day07.part1("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
      43210

      iex> AdventOfCode.Day07.part1("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")
      54321

      iex> AdventOfCode.Day07.part1("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0")
      65210

  """
  def part1(input) do
    program = parse(input)

    possible_sequences(0..4)
    |> Enum.map(fn sequence -> run_phase_sequence(program, sequence) end)
    |> Enum.max()
  end

  def part2(input) do
    # TODO
    input
  end

  defp parse(input) do
    String.trim(input)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp possible_sequences(range) do
    for a <- range,
        b <- range,
        c <- range,
        d <- range,
        e <- range,
        Enum.uniq([a, b, c, d, e]) |> length() |> Kernel.==(5),
        do: [a, b, c, d, e]
  end

  defp run_phase_sequence(program, sequence, input \\ 0) do
    for phase_input <- sequence, reduce: input do
      input -> AdventOfCode.Day05.run_program(program, 0, [input, phase_input])
    end
  end
end

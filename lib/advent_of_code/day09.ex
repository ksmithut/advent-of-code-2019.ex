defmodule AdventOfCode.Day09 do
  alias AdventOfCode.IntCode

  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day09.part1("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99") |> Enum.join(",")
      "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"

      iex> AdventOfCode.Day09.part1("1102,34915192,34915192,7,4,7,99,0") |> List.last()
      1219070632396864

      iex> AdventOfCode.Day09.part1("104,1125899906842624,99") |> List.last()
      1125899906842624

  """
  def part1(input) do
    IntCode.parse_program(input)
    |> run_program(1)
  end

  def part2(input) do
    IntCode.parse_program(input)
    |> run_program(2)
    |> List.last()
  end

  defp run_program(program, input) do
    pid = IntCode.run_program(program)
    send(pid, {:message, self(), input})
    run_loop(pid, [])
  end

  defp run_loop(pid, output) do
    receive do
      {:message, ^pid, value} -> run_loop(pid, output ++ [value])
      {:end_program, ^pid, _} -> output
    end
  end
end

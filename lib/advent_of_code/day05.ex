defmodule AdventOfCode.Day05 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day05.part1("3,0,4,0,99", input_value: 7)
      7

      iex> AdventOfCode.Day05.part1("3,0,4,0,99", input_value: 25)
      25

      iex> AdventOfCode.Day05.part1("1002,4,3,4,33", input_value: nil)
      nil

      iex> AdventOfCode.Day05.part2("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", input_value: 0)
      0

      iex> AdventOfCode.Day05.part2("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", input_value: 1)
      1

      iex> AdventOfCode.Day05.part2("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", input_value: 0)
      0

      iex> AdventOfCode.Day05.part2("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", input_value: 1)
      1

      iex> AdventOfCode.Day05.part2("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", input_value: 7)
      999

      iex> AdventOfCode.Day05.part2("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", input_value: 8)
      1000

      iex> AdventOfCode.Day05.part2("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", input_value: 9)
      1001

  """
  def part1(input, opts \\ [input_value: 1]) do
    AdventOfCode.IntCode.parse_program(input)
    |> run_program(opts[:input_value])
  end

  def part2(input, opts \\ [input_value: 5]) do
    AdventOfCode.IntCode.parse_program(input)
    |> run_program(opts[:input_value])
  end

  defp run_program(program, input) do
    pid = AdventOfCode.IntCode.run_program(program)
    send(pid, {:message, self(), input})
    {:ok, output, ended} = recieve_until_non_zero(pid)

    if ended do
      output
    else
      receive do
        {:message, ^pid, value} -> {:error, :non_zero_output, value}
        {:end_program, ^pid, _} -> output
      end
    end
  end

  defp recieve_until_non_zero(pid, previous_output \\ nil) do
    receive do
      {:message, ^pid, 0} -> recieve_until_non_zero(pid, 0)
      {:message, ^pid, value} -> {:ok, value, false}
      {:end_program, ^pid, _state} -> {:ok, previous_output, true}
    end
  end
end

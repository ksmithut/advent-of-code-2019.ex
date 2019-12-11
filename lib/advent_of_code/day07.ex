defmodule AdventOfCode.Day07 do
  alias AdventOfCode.IntCode

  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day07.part1("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
      43210

      iex> AdventOfCode.Day07.part1("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")
      54321

      iex> AdventOfCode.Day07.part1("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0")
      65210

      iex> AdventOfCode.Day07.part2("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")
      139629729

      iex> AdventOfCode.Day07.part2("3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10")
      18216

  """
  def part1(input) do
    program = IntCode.parse_program(input)

    possible_sequences(0..4)
    |> Enum.map(fn sequence -> run_phase_sequence(program, sequence) end)
    |> Enum.max()
  end

  def part2(input) do
    program = IntCode.parse_program(input)

    possible_sequences(5..9)
    |> Enum.map(fn sequence -> loop_phase_sequence(program, sequence) end)
    |> Enum.max()
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

  defp run_phase_sequence(program, sequence) do
    for phase_setting <- sequence, reduce: 0 do
      input -> run_amp_to_completion(program, phase_setting, input)
    end
  end

  defp loop_phase_sequence(program, [a, b, c, d, e]) do
    pid_e = IntCode.run_program(program)
    pid_d = IntCode.run_program(program, pid_e)
    pid_c = IntCode.run_program(program, pid_d)
    pid_b = IntCode.run_program(program, pid_c)
    pid_a = IntCode.run_program(program, pid_b)
    send(pid_a, {:message, self(), a})
    send(pid_a, {:message, self(), 0})
    send(pid_b, {:message, self(), b})
    send(pid_c, {:message, self(), c})
    send(pid_d, {:message, self(), d})
    send(pid_e, {:message, self(), e})
    loop_back(pid_e, pid_a)
  end

  defp loop_back(pid_end, pid_beginning, last_value \\ nil) do
    receive do
      {:message, ^pid_end, value} ->
        send(pid_beginning, {:message, pid_end, value})
        loop_back(pid_end, pid_beginning, value)

      {:end_program, ^pid_end, _} ->
        last_value
    end
  end

  defp run_amp_to_completion(program, phase_setting, input) do
    pid = IntCode.run_program(program)
    send(pid, {:message, self(), phase_setting})
    send(pid, {:message, self(), input})
    run_loop(pid)
  end

  defp run_loop(pid, prev_output \\ nil) do
    receive do
      {:message, ^pid, value} ->
        send(pid, {:message, self(), value})
        run_loop(pid, value)

      {:end_program, ^pid, _} ->
        prev_output
    end
  end
end

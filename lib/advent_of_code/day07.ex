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
      input -> run_program(program, 0, [input, phase_input])
    end
  end

  defp run_program(state, pos, input) do
    [_mode3, mode2, mode1 | opcode_parts] =
      Enum.at(state, pos)
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> String.graphemes()

    opcode = Enum.join(opcode_parts)
    a = param_value(pos + 1, mode1, state)
    aIm = param_value(pos + 1, "1", state)
    b = param_value(pos + 2, mode2, state)
    cIm = param_value(pos + 3, "1", state)

    cond do
      opcode == "99" ->
        List.first(input)

      # output != nil -> {:error, :non_zero_output, output}
      opcode == "01" ->
        List.replace_at(state, cIm, a + b) |> run_program(pos + 4, input)

      opcode == "02" ->
        List.replace_at(state, cIm, a * b) |> run_program(pos + 4, input)

      opcode == "03" and length(input) == 0 ->
        {:error, :no_input}

      opcode == "03" ->
        {value, input} = List.pop_at(input, length(input) - 1)
        List.replace_at(state, aIm, value) |> run_program(pos + 2, input)

      opcode == "04" ->
        run_program(state, pos + 2, [a | input])

      opcode == "05" and a != 0 ->
        run_program(state, b, input)

      opcode == "05" ->
        run_program(state, pos + 3, input)

      opcode == "06" and a == 0 ->
        run_program(state, b, input)

      opcode == "06" ->
        run_program(state, pos + 3, input)

      opcode == "07" and a < b ->
        List.replace_at(state, cIm, 1) |> run_program(pos + 4, input)

      opcode == "07" ->
        List.replace_at(state, cIm, 0) |> run_program(pos + 4, input)

      opcode == "08" and a == b ->
        List.replace_at(state, cIm, 1) |> run_program(pos + 4, input)

      opcode == "08" ->
        List.replace_at(state, cIm, 0) |> run_program(pos + 4, input)

      true ->
        {:error, :unknown_command, opcode}
    end
  end

  defp param_value(nil, _, _), do: nil
  defp param_value(value, "1", state), do: Enum.at(state, value)

  defp param_value(value, "0", state),
    do: param_value(value, "1", state) |> param_value("1", state)
end

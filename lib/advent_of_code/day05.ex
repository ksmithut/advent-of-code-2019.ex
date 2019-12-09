defmodule AdventOfCode.Day05 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day05.part1("3,0,4,0,99", input_value: [7])
      7

      iex> AdventOfCode.Day05.part1("3,0,4,0,99", input_value: [25])
      25

      iex> AdventOfCode.Day05.part1("1002,4,3,4,33", input_value: [])
      nil

      iex> AdventOfCode.Day05.part2("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", input_value: [0])
      0

      iex> AdventOfCode.Day05.part2("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", input_value: [1])
      1

      iex> AdventOfCode.Day05.part2("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", input_value: [0])
      0

      iex> AdventOfCode.Day05.part2("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", input_value: [1])
      1

      iex> AdventOfCode.Day05.part2("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", input_value: [7])
      999

      iex> AdventOfCode.Day05.part2("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", input_value: [8])
      1000

      iex> AdventOfCode.Day05.part2("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", input_value: [9])
      1001

  """
  def part1(input, opts \\ [input_value: [1]]) do
    parse(input)
    |> run_program(0, opts[:input_value])
  end

  def part2(input, opts \\ [input_value: [5]]) do
    parse(input)
    |> run_program(0, opts[:input_value])
  end

  defp parse(input) do
    String.trim(input)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def run_program(state, pos, input \\ []) do
    [mode3, mode2, mode1 | opcode_parts] =
      Enum.at(state, pos)
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> String.graphemes()

    opcode = Enum.join(opcode_parts)
    a = param_value(pos + 1, mode1, state)
    aIm = param_value(pos + 1, "1", state)
    b = param_value(pos + 2, mode2, state)
    _c = param_value(pos + 3, mode3, state)
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

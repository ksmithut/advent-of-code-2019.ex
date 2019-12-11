defmodule AdventOfCode.IntCode do
  def parse_program(input) do
    String.trim(input)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {value, pos}, map -> Map.put(map, pos, value) end)
  end

  def run_program(program, caller \\ self()) do
    spawn(fn -> run(program, caller, 0) end)
  end

  defp run(state, caller, pos) do
    [_mode3, mode2, mode1 | opcode_parts] =
      Map.get(state, pos)
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
        send(caller, {:end_program, self(), state})

      opcode == "01" ->
        Map.put(state, cIm, a + b) |> run(caller, pos + 4)

      opcode == "02" ->
        Map.put(state, cIm, a * b) |> run(caller, pos + 4)

      opcode == "03" ->
        receive do
          {:message, _, input} ->
            Map.put(state, aIm, input) |> run(caller, pos + 2)
        end

      opcode == "04" ->
        send(caller, {:message, self(), a})
        run(state, caller, pos + 2)

      opcode == "05" and a != 0 ->
        run(state, caller, b)

      opcode == "05" ->
        run(state, caller, pos + 3)

      opcode == "06" and a == 0 ->
        run(state, caller, b)

      opcode == "06" ->
        run(state, caller, pos + 3)

      opcode == "07" and a < b ->
        Map.put(state, cIm, 1) |> run(caller, pos + 4)

      opcode == "07" ->
        Map.put(state, cIm, 0) |> run(caller, pos + 4)

      opcode == "08" and a == b ->
        Map.put(state, cIm, 1) |> run(caller, pos + 4)

      opcode == "08" ->
        Map.put(state, cIm, 0) |> run(caller, pos + 4)

      true ->
        send(caller, {:error, self(), :unknown_command, opcode})
    end
  end

  defp param_value(nil, _, _), do: nil
  defp param_value(value, "1", state), do: Map.get(state, value)

  defp param_value(value, "0", state),
    do: param_value(value, "1", state) |> param_value("1", state)
end

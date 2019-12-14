defmodule AdventOfCode.IntCode do
  def parse_program(input) do
    String.trim(input)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce(%{relative_base: 0}, fn {value, pos}, map -> Map.put(map, pos, value) end)
  end

  def run_program(program, caller \\ self()) do
    spawn(fn -> run(program, caller) end)
  end

  defp run(state, caller, pointer \\ 0) do
    [mode3, mode2, mode1 | opcode_parts] =
      Map.get(state, pointer)
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> String.graphemes()

    opcode = Enum.join(opcode_parts)

    input = fn
      {value, "0"} -> Map.get(state, value, 0)
      {value, "1"} -> value
      {value, "2"} -> Map.get(state, :relative_base) |> (&Map.get(state, &1 + value, 0)).()
    end

    output = fn
      {value, "0"} -> value
      {value, "2"} -> Map.get(state, :relative_base) + value
    end

    a = {Map.get(state, pointer + 1, 0), mode1}
    b = {Map.get(state, pointer + 2, 0), mode2}
    c = {Map.get(state, pointer + 3, 0), mode3}

    cond do
      opcode == "01" ->
        Map.put(state, output.(c), input.(a) + input.(b)) |> run(caller, pointer + 4)

      opcode == "02" ->
        Map.put(state, output.(c), input.(a) * input.(b)) |> run(caller, pointer + 4)

      opcode == "03" ->
        receive do
          {:message, _, input} -> Map.put(state, output.(a), input) |> run(caller, pointer + 2)
        end

      opcode == "04" ->
        send(caller, {:message, self(), input.(a)})
        run(state, caller, pointer + 2)

      opcode == "05" and input.(a) != 0 ->
        run(state, caller, input.(b))

      opcode == "05" ->
        run(state, caller, pointer + 3)

      opcode == "06" and input.(a) == 0 ->
        run(state, caller, input.(b))

      opcode == "06" ->
        run(state, caller, pointer + 3)

      opcode == "07" and input.(a) < input.(b) ->
        Map.put(state, output.(c), 1) |> run(caller, pointer + 4)

      opcode == "07" ->
        Map.put(state, output.(c), 0) |> run(caller, pointer + 4)

      opcode == "08" and input.(a) == input.(b) ->
        Map.put(state, output.(c), 1) |> run(caller, pointer + 4)

      opcode == "08" ->
        Map.put(state, output.(c), 0) |> run(caller, pointer + 4)

      opcode == "09" ->
        Map.get(state, :relative_base)
        |> (&Map.put(state, :relative_base, &1 + input.(a))).()
        |> run(caller, pointer + 2)

      opcode == "99" ->
        send(caller, {:end_program, self(), state})
    end
  end
end

defmodule AdventOfCode.Day13 do
  alias AdventOfCode.IntCode

  @doc ~S"""
  ## Examples

      # iex> AdventOfCode.Day13.part1("hello")
      # "hello"

      # iex> AdventOfCode.Day13.part2("hello")
      # "hello"

  """
  def part1(input) do
    IntCode.parse_program(input)
    |> get_num_blocks()
  end

  def part2(input) do
    IntCode.parse_program(input)
    |> play_game()
    |> Map.get(:score)
  end

  defp get_num_blocks(program) do
    pid = IntCode.run_program(program)

    get_tile_loop(pid)
    |> Map.values()
    |> Enum.count(fn value -> value == 2 end)
  end

  defp play_game(program) do
    pid =
      Map.put(program, 0, 2)
      |> IntCode.run_program()

    send(pid, {:message, self(), 0})
    game_loop(pid, &play/3)
  end

  defp game_loop(pid, func, map \\ %{}) do
    case get_tile(pid, map) do
      {:end, map} ->
        map

      {action, map} ->
        func.(pid, action, map)
        game_loop(pid, func, map)
    end
  end

  defp play(pid, :ball_move, %{paddle: {paddle_x, _}, ball: {ball_x, _}} = map) do
    Process.sleep(25)
    IO.puts(render_map(map))

    cond do
      paddle_x < ball_x -> send(pid, {:message, self(), 1})
      paddle_x > ball_x -> send(pid, {:message, self(), -1})
      true -> send(pid, {:message, self(), 0})
    end
  end

  # IO.puts(render_map(map))
  defp play(_, _, _), do: nil

  defp get_tile_loop(pid, map \\ %{}) do
    case get_tile(pid, map) do
      {:end, map} -> map
      map -> get_tile_loop(pid, map)
    end
  end

  defp get_tile(pid, map) do
    case receive_count(pid, 3) do
      [-1, 0, score] ->
        Map.put(map, :score, score)
        |> (&{:score_update, &1}).()

      [x, y, 3] ->
        Map.put(map, {x, y}, 3)
        |> Map.put(:paddle, {x, y})
        |> (&{:paddle_move, &1}).()

      [x, y, 4] ->
        Map.put(map, {x, y}, 4)
        |> Map.put(:ball, {x, y})
        |> (&{:ball_move, &1}).()

      [x, y, tile] ->
        Map.put(map, {x, y}, tile)
        |> (&{:tile_update, &1}).()

      nil ->
        {:end, map}
    end
  end

  defp receive_count(pid, count, output \\ [])
  defp receive_count(_, 0, output), do: output

  defp receive_count(pid, count, output) do
    receive do
      {:message, ^pid, value} -> receive_count(pid, count - 1, output ++ [value])
      {:end_program, ^pid, _} -> nil
    end
  end

  defp render_map(map) do
    keys =
      Map.keys(map)
      |> Enum.filter(fn
        {_, _} -> true
        _ -> false
      end)

    x_values = Enum.map(keys, fn {x, _} -> x end)
    y_values = Enum.map(keys, fn {_, y} -> y end)
    min_x = Enum.min(x_values)
    max_x = Enum.max(x_values)
    min_y = Enum.min(y_values)
    max_y = Enum.max(y_values)

    min_y..max_y
    |> Enum.map(fn y ->
      min_x..max_x
      |> Enum.map(fn x ->
        Map.get(map, {x, y}, 0)
        |> render_piece({x, y})
      end)
      |> Enum.join()
    end)
    |> Enum.concat(["", "Score: #{map.score}"])
    |> Enum.join("\n")
  end

  defp render_piece(0, _), do: " "
  defp render_piece(1, _), do: "@"
  defp render_piece(2, _), do: "#"
  defp render_piece(3, _), do: "_"
  defp render_piece(4, _), do: "*"
end

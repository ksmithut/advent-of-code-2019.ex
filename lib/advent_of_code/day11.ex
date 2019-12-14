defmodule AdventOfCode.Day11 do
  alias AdventOfCode.IntCode

  @doc ~S"""
  ## Examples

      # iex> AdventOfCode.Day11.part1("hello")
      # "hello"

      # iex> AdventOfCode.Day11.part2("hello")
      # "hello"

  """
  def part1(input) do
    IntCode.parse_program(input)
    |> start_painting_robot()
    |> map_size()
  end

  def part2(input) do
    IntCode.parse_program(input)
    |> start_painting_robot(%{{0, 0} => 1})
    |> render_hull()
  end

  defp start_painting_robot(program, initial_map \\ %{}) do
    pid = IntCode.run_program(program)
    paint_loop(pid, initial_map, :up, {0, 0})
  end

  defp paint_loop(pid, map, direction, pos) do
    current_color = Map.get(map, pos, 0)
    send(pid, {:message, self(), current_color})
    paint_color(pid, map, direction, pos)
  end

  defp paint_color(pid, map, direction, pos) do
    receive do
      {:message, ^pid, color} ->
        next_map = Map.put(map, pos, color)
        turn(pid, next_map, direction, pos)

      {:end_program, ^pid, _} ->
        map
    end
  end

  defp turn(pid, map, direction, pos) do
    next_direction =
      receive do
        {:message, ^pid, 0} -> turn_left(direction)
        {:message, ^pid, 1} -> turn_right(direction)
      end

    next_pos = move(pos, next_direction)
    paint_loop(pid, map, next_direction, next_pos)
  end

  defp turn_left(:up), do: :left
  defp turn_left(:left), do: :down
  defp turn_left(:down), do: :right
  defp turn_left(:right), do: :up

  defp turn_right(:up), do: :right
  defp turn_right(:right), do: :down
  defp turn_right(:down), do: :left
  defp turn_right(:left), do: :up

  defp move({x, y}, :up), do: {x, y - 1}
  defp move({x, y}, :left), do: {x - 1, y}
  defp move({x, y}, :down), do: {x, y + 1}
  defp move({x, y}, :right), do: {x + 1, y}

  defp render_hull(map) do
    coords = Map.keys(map)
    x_coords = coords |> Enum.map(fn {x, _} -> x end)
    y_coords = coords |> Enum.map(fn {_, y} -> y end)
    min_x = x_coords |> Enum.min()
    max_x = x_coords |> Enum.max()
    min_y = y_coords |> Enum.min()
    max_y = y_coords |> Enum.max()

    min_y..max_y
    |> Enum.map(fn y ->
      min_x..max_x
      |> Enum.map(fn x ->
        Map.get(map, {x, y}, 0)
        |> render_point()
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
  end

  defp render_point(0), do: " "
  defp render_point(1), do: "#"
end

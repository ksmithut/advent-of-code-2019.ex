defmodule AdventOfCode.Day12 do
  @line_regex ~r/^<x=(?<x>.+), y=(?<y>.+), z=(?<z>.+)>$/
  @doc ~S"""
  ## Examples

      # iex> AdventOfCode.Day12.part1("hello")
      # "hello"

      # iex> AdventOfCode.Day12.part2("hello")
      # "hello"

  """
  def part1(input) do
    parse(input)
    |> simulate_times(1000)
    |> total_energy()
  end

  def part2(input) do
    moons = parse(input)

    [:x, :y, :z]
    |> Enum.map(&simulate_until_repeat(moons, &1))
    |> Enum.reduce(&lcm/2)
  end

  defp parse(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(fn line -> {parse_pos(line), %{x: 0, y: 0, z: 0}} end)
  end

  defp parse_pos(line) do
    Regex.named_captures(@line_regex, line)
    |> Enum.map(fn {key, value} ->
      {String.to_atom(key), String.to_integer(value)}
    end)
    |> Map.new()
  end

  defp simulate_times(moons, 0), do: moons

  defp simulate_times(moons, steps) do
    simulate(moons)
    |> simulate_times(steps - 1)
  end

  defp simulate(moons) do
    num_moons = length(moons) - 1

    for a <- 0..num_moons, b <- 0..num_moons, a != b, reduce: moons do
      moons ->
        {pos_a, vel_a} = Enum.at(moons, a)
        {pos_b, _} = Enum.at(moons, b)

        new_vel_a =
          Enum.map(vel_a, fn {axis, value} ->
            {axis, value + apply_gravity(pos_a[axis], pos_b[axis])}
          end)
          |> Map.new()

        List.replace_at(moons, a, {pos_a, new_vel_a})
    end
    |> Enum.map(&apply_velocity/1)
  end

  defp apply_gravity(a, b) when a > b, do: -1
  defp apply_gravity(a, b) when a < b, do: 1
  defp apply_gravity(_, _), do: 0

  defp apply_velocity({pos, vel}) do
    Enum.map(pos, fn {axis, value} -> {axis, value + vel[axis]} end)
    |> Map.new()
    |> (&{&1, vel}).()
  end

  defp total_energy(moons), do: Enum.map(moons, &moon_energy/1) |> Enum.sum()
  defp moon_energy({pos, vel}), do: pos_energy(pos) * pos_energy(vel)
  defp pos_energy(%{x: x, y: y, z: z}), do: abs(x) + abs(y) + abs(z)

  defp simulate_until_repeat(moons, axis) do
    moons =
      Enum.map(moons, fn {pos, vel} ->
        {Map.take(pos, [axis]), Map.take(vel, [axis])}
      end)

    simulate_until_repeat(simulate(moons), axis, moons, 1)
  end

  defp simulate_until_repeat(moons, _, initial_state, count) when moons == initial_state,
    do: count

  defp simulate_until_repeat(moons, axis, initial_state, count) do
    simulate_until_repeat(simulate(moons), axis, initial_state, count + 1)
  end

  defp lcm(a, b), do: (a * b / gcd(a, b)) |> trunc()
  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))
end

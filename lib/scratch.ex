defmodule Test do
  @base_pattern [0, 1, 0, -1]
  def generate_pattern(len, iteration) do
    pattern = Enum.flat_map(@base_pattern, &replicate(iteration + 1, &1))
    times = ((len + 1) / length(pattern)) |> Float.ceil() |> trunc()
    replicate(times, pattern) |> Enum.flat_map(& &1) |> Enum.slice(1, len)
  end

  def replicate(n, x), do: for(_ <- 1..n, do: x)

  def value(index, spread \\ 0) do
    spread = spread + 1
    num = div(index + 3 * spread, spread)
    abs(rem(num, 4) - 2) - 1
  end
end

# for(x <- 0..15, do: Test.value(x, 5))
# |> Enum.join(",")
# |> IO.inspect()

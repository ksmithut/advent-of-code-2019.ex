defmodule Test do
  defp lcm(a, b), do: a * b / gcd(a, b)

  def gcd(a, 0), do: a
  def gcd(a, b), do: gcd(b, rem(a, b))
end

defmodule Mix.Tasks.Generate do
  use Mix.Task

  def run([]) do
    IO.puts("You must supply an argument (day)")
  end

  def run([day]) do
    String.to_integer(day)
    |> AdventOfCode.generate()
  end
end

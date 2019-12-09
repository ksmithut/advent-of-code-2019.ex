defmodule Mix.Tasks.Day do
  use Mix.Task

  def run([]) do
    IO.puts("You must supply two arguments (day and part)")
  end

  def run([day]) do
    run([day, "1"])
  end

  def run([day, part | _rest]) do
    output = AdventOfCode.run(String.to_integer(day), String.to_integer(part))

    if is_binary(output),
      do: IO.puts(output),
      else: IO.inspect(output)
  end
end

# AdventOfCode

A boilerplate for running [Advent of Code](https://adventofcode.com) puzzles in
elixir.

# Prerequisites

You'll need to install erlang and elixir onto your machine.

## Mac

```sh
brew install erlang elixir
```

## Linux (Ubuntu)

```sh
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb -O "erlang.deb"
sudo dpkg -i "erlang.deb"
sudo apt-get update
sudo apt-get install -y esl-erlang
sudo apt-get install -y elixir
```

# Running

To generate the file for a day, run:

```sh
mix generate 1 # For day 1. If run again, it will not create a new file
mix compile
```

This generates a file at `lib/advent_of_code/dayXX.ex` where `XX` is the
zero-padded day of the puzzle. It also generates an input file for you to paste
in your input at the root of your project directory `dayXX.txt`.

Your file will look something like this:

```elixir
defmodule AdventOfCode.Day01 do
  @doc ~S"""
  ## Examples

      iex> AdventOfCode.Day01.part1("hello")
      "hello"

      iex> AdventOfCode.Day01.part2("hello")
      "hello"

  """
  def part1(input) do
    input
  end

  def part2(input) do
    input
  end
end
```

When you run:

```sh
mix day 1 1 # first "1" is for day 1, second "1" is for part 1
```

it will run your AdventOfCode.Day01.part1() function passing in the input you
have in `day01.txt`. It also has some doctests included so you can put in other
examples. You can see the format of the doctests in the generated file. If you
want to add more tests, it follows this format:

```sh
iex> AdventOfCode.Day01.part1("input")
"expected output"
```

Then you need to add your module to the tests by editting
`test/advent_of_code_test.exs` and adding your module to the doctests like so:

```elixir
defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode
  doctest AdventOfCode.Day01 # This line was added
end
```

Now when you run `mix test`, it will run your doctests for that module.

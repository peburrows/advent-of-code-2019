defmodule Advent19.Day09 do
  alias Advent19.IntCode

  def part1(code, input) do
    input = String.to_integer(input)
    IntCode.run(code, [input]) |> IntCode.full_output()
  end

  def part2 do
  end
end

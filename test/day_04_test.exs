defmodule Advent19.Day04Test do
  use ExUnit.Case

  import Advent19.Day04

  test "part1" do
    assert valid?(111_111)
    refute valid?(223_450)
    refute valid?(123_789)
  end

  test "part2" do
    assert valid2?(112_233)
    refute valid2?(123_444)
    assert valid2?(111_122)
    refute valid2?(699_999)
    refute valid2?(699_944)
  end
end

defmodule Advent19.Day01Test do
  use ExUnit.Case

  import Advent19.Day01

  test "part1" do
    assert 2 = part1(12)
    assert 2 = part1(14)
    assert 654 = part1(1969)
    assert 33583 = part1(100_756)
  end

  test "part2" do
    assert 2 = part2("14")
    assert 966 = part2(1969)
    assert 50346 = part2(100_756)
  end
end

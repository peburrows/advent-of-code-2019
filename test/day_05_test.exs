defmodule Advent19.Day05Test do
  use ExUnit.Case

  import Advent19.Day05

  test "part1" do
    assert [2, 0, 0, 0, 99] == part1([1, 0, 0, 0, 99]) |> result()
    assert [2, 3, 0, 6, 99] == part1([2, 3, 0, 3, 99]) |> result()
    assert [2, 4, 4, 5, 99, 9801] == part1([2, 4, 4, 5, 99, 0]) |> result()
    assert [30, 1, 1, 4, 2, 5, 6, 0, 99] == part1([1, 1, 1, 4, 99, 5, 6, 0, 99]) |> result()

    assert [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50] ==
             part1("1,9,10,3,2,3,11,0,99,30,40,50") |> result()

    assert [3, 2, 30] == part1("3,2", 30) |> result()
    assert "55" == part1("3,0,4,0,99", 55) |> output
    assert "50" == part1("4,2,50") |> output

    assert [1101, 100, -1, 4, 99] == part1([1101, 100, -1, 4, 0]) |> result
    assert [1002, 4, 3, 4, 99] = part1("1002,4,3,4,33") |> result
  end

  @tag :skip
  test "part2" do
  end
end

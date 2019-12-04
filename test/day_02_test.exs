defmodule Advent19.Day02Test do
  use ExUnit.Case

  import Advent19.Day02

  test "part1" do
    assert [2, 0, 0, 0, 99] == part1([1, 0, 0, 0, 99]) |> Map.values()
    assert [2, 3, 0, 6, 99] == part1([2, 3, 0, 3, 99]) |> Map.values()
    assert [2, 4, 4, 5, 99, 9801] == part1([2, 4, 4, 5, 99, 0]) |> Map.values()
    assert [30, 1, 1, 4, 2, 5, 6, 0, 99] == part1([1, 1, 1, 4, 99, 5, 6, 0, 99]) |> Map.values()

    assert [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50] ==
             part1("1,9,10,3,2,3,11,0,99,30,40,50") |> Map.values()
  end

  @tag :skip
  # test "part2" do
  #   input = nil
  #   result = part2(input)

  #   assert result
  # end
end

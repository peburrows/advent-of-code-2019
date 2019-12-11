defmodule Advent19.Day09Test do
  use ExUnit.Case

  import Advent19.Day09
  alias Advent19.IntCode

  @tag timeout: 5_000
  test "part1" do
    assert [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99] ==
             IntCode.run("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
             |> IntCode.full_output()

    [output] = IntCode.run("1102,34915192,34915192,7,4,7,99,0") |> IntCode.full_output()
    assert output |> to_string |> String.length() == 16

    assert [1_125_899_906_842_624] ==
             IntCode.run("104,1125899906842624,99") |> IntCode.full_output()
  end

  @tag :skip
  test "part2" do
  end
end

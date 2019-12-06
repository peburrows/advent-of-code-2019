defmodule Advent19.Day06Test do
  use ExUnit.Case

  import Advent19.Day06

  test "part1" do
    input = """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    """

    assert 42 == part1(input)
  end

  test "part2" do
    input = """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    K)YOU
    I)SAN
    """

    assert {4, "D"} == part2(input)
  end
end

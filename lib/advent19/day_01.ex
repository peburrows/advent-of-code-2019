defmodule Advent19.Day01 do
  def part1(masses) when is_list(masses) do
    Enum.reduce(masses, 0, fn mass, acc ->
      (String.to_integer(mass) |> part1) + acc
    end)
  end

  def part1(masses) when is_binary(masses) do
    masses
    |> String.split("\n", trim: true)
    |> part1
  end

  def part1(mass) do
    mass
    |> Integer.floor_div(3)
    |> Kernel.-(2)
  end

  # 1. calculate the fuel for the mass
  # 2. recursively calculate the fuel for the fuel
  def part2(masses) when is_list(masses) do
    Enum.reduce(masses, 0, fn m, acc ->
      acc + part2(m)
    end)
  end

  def part2(mass) when is_binary(mass) do
    mass
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> part2
  end

  def part2(mass) do
    case part1(mass) do
      fuel when fuel <= 0 -> 0
      fuel -> fuel + part2(fuel)
    end
  end
end

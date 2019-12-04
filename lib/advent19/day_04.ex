defmodule Advent19.Day04 do
  def part1(<<start::binary-size(6), "-", finish::binary-size(6)>>) do
    start = String.to_integer(start)
    finish = String.to_integer(finish)

    Enum.reduce(start..finish, 0, fn pword, count ->
      if valid?(pword), do: count + 1, else: count
    end)
  end

  def valid?(pword) when pword < 100_000, do: false
  def valid?(pword) when pword > 999_000, do: false

  def valid?(pword) do
    pword
    |> to_string
    |> String.split("", trim: true)
    |> Enum.reduce_while({nil, false, false}, fn int, {prev, doubled, _inc} ->
      doubled = if doubled || int == prev, do: true, else: false
      inc = int >= prev

      if inc, do: {:cont, {int, doubled, true}}, else: {:halt, {int, doubled, false}}
    end)
    |> case do
      {_, true, true} -> true
      _ -> false
    end
  end

  def valid2?(pword) when is_binary(pword) or is_integer(pword) do
    pword
    |> to_string
    |> String.split("", trim: true)
    |> valid2?(nil, false)
  end

  def valid2?([], _prev, doubled),
    do: doubled

  def valid2?([a, b, c | rest], _prev, db) when a == b and b == c,
    do: valid2?([c | rest], b, db)

  def valid2?([a, b | rest], prev, _db) when a == b and b != prev,
    do: valid2?([b | rest], a, true)

  def valid2?([a, b | rest], _prev, db) when a < b,
    do: valid2?([b | rest], a, db)

  def valid2?([a, b | _rest], _prev, _db) when a > b,
    do: false

  def valid2?([p | rest], _prev, db),
    do: valid2?(rest, p, db)

  def part2(<<start::binary-size(6), "-", finish::binary-size(6)>>) do
    start = String.to_integer(start)
    finish = String.to_integer(finish)

    Enum.reduce(start..finish, 0, fn pword, count ->
      if valid2?(pword), do: count + 1, else: count
    end)
  end
end

defmodule Advent19.Day02 do
  def part1(input) when is_binary(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> part1
  end

  # I think we need to work with a map
  def part1(nums) do
    nums
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {v, i}, acc ->
      Map.put(acc, i, v)
    end)
    |> do_part1(0)
  end

  defp do_part1(vals, i) do
    vals
    |> Map.get(i)
    |> perform(vals, i)
    |> case do
      {nil, vals} -> vals
      {ind, vals} -> do_part1(vals, ind)
    end
  end

  defp perform(nil, vals, _), do: {nil, vals}
  defp perform(99, vals, _), do: {nil, vals}

  defp perform(calc, vals, i) do
    ai = Map.get(vals, i + 1)
    a = Map.get(vals, ai)
    bi = Map.get(vals, i + 2)
    b = Map.get(vals, bi)
    dest = Map.get(vals, i + 3)

    result =
      case calc do
        1 -> a + b
        2 -> a * b
      end

    {i + 4, Map.put(vals, dest, result)}
  end

  # need to convert this to an integer
  def part2(input, desired) when is_binary(desired),
    do: part2(input, String.to_integer(desired))

  def part2(input, desired) when is_binary(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> part2(desired)
  end

  def part2(input, desired) do
    input_map =
      input
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {v, i}, acc ->
        Map.put(acc, i, v)
      end)

    do_part2(input_map, desired)
  end

  defp do_part2(input, desired) do
    # Elixir makes this a little more difficult since there is no while loop
    Enum.reduce_while(0..99, nil, fn x, _acc ->
      Enum.reduce_while(0..99, nil, fn y, _acc ->
        input
        |> Map.put(1, x)
        |> Map.put(2, y)
        |> do_part1(0)
        |> Map.get(0)
        |> case do
          ^desired -> {:halt, {desired, x, y}}
          _ -> {:cont, nil}
        end
      end)
      |> case do
        {^desired, x, y} -> {:halt, {x, y}}
        _ -> {:cont, nil}
      end
    end)
  end
end

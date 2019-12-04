defmodule Advent19.Day03 do
  def part1(input) do
    [a, b] =
      input
      |> String.trim()
      |> String.split("\n", trim: true)

    part1(a, b)
  end

  def part1(a, b) do
    # we want to find the intersection(s) of two paths, so:
    # 1. calculate all points each path traverses, store in a MapSet
    # 2. take the intersection of the two MapSets
    # 3. return the distance of the intersection that is nearest the origin

    va = all_points_on_path(a)
    vb = all_points_on_path(b)

    mva = MapSet.new(va)
    mvb = MapSet.new(vb)

    MapSet.intersection(mva, mvb)
    |> MapSet.to_list()
    |> Enum.reduce(nil, fn {x, y}, min ->
      dist = abs(x) + abs(y)

      case min do
        nil -> dist
        val when val > dist -> dist
        _ -> min
      end
    end)
  end

  def part2(input) do
    [a, b] =
      input
      |> String.trim()
      |> String.split("\n", trim: true)

    part2(a, b)
  end

  def part2(a, b) do
    va = all_points_on_path(a)
    vb = all_points_on_path(b)

    mva = MapSet.new(va)
    mvb = MapSet.new(vb)

    MapSet.intersection(mva, mvb)
    |> MapSet.to_list()
    |> Enum.reduce(nil, fn point, min ->
      dist_a = Enum.find_index(va, fn p -> p == point end) + 1
      dist_b = Enum.find_index(vb, fn p -> p == point end) + 1
      dist = dist_a + dist_b

      case min do
        nil -> dist
        val when val > dist -> dist
        _ -> min
      end
    end)
  end

  defp all_points_on_path(path) do
    path
    |> String.split(",", trim: true)
    |> traverse_path({0, 0, []})
  end

  defp traverse_path([], {_x, _y, acc}), do: Enum.reverse(acc)

  defp traverse_path([<<d::binary-size(1), count::binary>> | rest], {x, y, acc}) do
    count = count |> String.to_integer()
    {x, y, acc} = gather_points(d, count, {x, y}, acc)
    # traverse_path(rest, {x, y, MapSet.union(acc, points)})
    traverse_path(rest, {x, y, acc})
  end

  defp gather_points("R", count, {x, y}, acc) do
    acc =
      Enum.reduce(0..(count - 1), acc, fn i, points ->
        [{x + i + 1, y} | points]
      end)

    {x + count, y, acc}
  end

  defp gather_points("L", count, {x, y}, acc) do
    acc =
      Enum.reduce(0..(count - 1), acc, fn i, points ->
        [{x - i - 1, y} | points]
      end)

    {x - count, y, acc}
  end

  defp gather_points("D", count, {x, y}, acc) do
    acc =
      Enum.reduce(0..(count - 1), acc, fn i, points ->
        [{x, y - i - 1} | points]
      end)

    {x, y - count, acc}
  end

  defp gather_points("U", count, {x, y}, acc) do
    acc =
      Enum.reduce(0..(count - 1), acc, fn i, points ->
        [{x, y + i + 1} | points]
      end)

    {x, y + count, acc}
  end
end

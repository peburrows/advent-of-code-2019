defmodule Advent19.Day06 do
  def part1(input) when is_binary(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> build_orbit_map
    |> count_all
  end

  def part2(input) when is_binary(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> build_orbit_map
    |> find_santa
  end

  defp build_orbit_map(orbits, acc \\ %{})
  defp build_orbit_map([], acc), do: acc

  defp build_orbit_map([orbit | rest], acc) do
    [a, b] = String.split(orbit, ")", trim: true)
    build_orbit_map(rest, Map.put(acc, b, a))
  end

  defp count_all(map) do
    Enum.reduce(map, 0, fn {k, _v}, acc ->
      acc + count(map, k)
    end)
  end

  defp count(map, planet, acc \\ 0)
  defp count(_map, "COM", acc), do: acc

  defp count(map, planet, acc) do
    count(map, Map.get(map, planet), acc + 1)
  end

  defp find_santa(map) do
    find_common_ancestor(map, "YOU", "SAN")
  end

  defp find_common_ancestor(map, a, b) do
    a_anc = ancestors(map, a)
    a_set = MapSet.new(a_anc)
    b_anc = ancestors(map, b)
    b_set = MapSet.new(b_anc)

    all =
      MapSet.intersection(a_set, b_set)
      |> MapSet.to_list()

    # we need to find which one is earliest
    # in both lists
    {distance, planet} =
      Enum.reduce(all, {nil, nil}, fn anc, {dist, planet} ->
        ai = Enum.find_index(a_anc, fn p -> p == anc end)
        bi = Enum.find_index(b_anc, fn p -> p == anc end)
        result = ai + bi

        case dist do
          nil -> {result, anc}
          val when val > result -> {result, anc}
          _ -> {dist, planet}
        end
      end)
  end

  defp ancestors(map, planet, acc \\ [])
  defp ancestors(map, "COM", acc), do: Enum.reverse(acc)

  defp ancestors(map, planet, acc) do
    parent = Map.get(map, planet)
    ancestors(map, parent, [parent | acc])
  end
end

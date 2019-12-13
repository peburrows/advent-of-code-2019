defmodule Advent19.Day10 do
  def part1(input) do
    {coords, _} =
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, "", trim: true)
      end)
      |> Enum.reduce({%{}, 0}, fn line, {acc, y} ->
        {acc, _x} =
          Enum.reduce(line, {acc, 0}, fn
            "#", {acc, x} ->
              {Map.put(acc, {x, y}, true), x + 1}

            _, {acc, x} ->
              {acc, x + 1}
          end)

        {acc, y + 1}
      end)

    with_most_visible(coords)
  end

  def part2 do
  end

  defp with_most_visible(coords) do
    coords
    |> Enum.reduce({nil, 0}, fn {point, _}, {best, count} ->
      point
      |> count_visible(coords)
      |> case do
        c when c > count -> {point, c}
        _ -> {best, count}
      end
    end)
  end

  defp count_visible(point, coords) do
    # check to see if each point can be seen from this particular point.
    # we need to start at the current point and radiate out from there...
    # I guess
    # iterate over each coordinate and calculate the distance + slope
    coords
    |> Enum.reduce(%{}, fn
      {^point, _}, acc ->
        # IO.inspect(point, label: :myself)
        acc

      # here, we can put in only the dis
      {p, _}, acc ->
        dir = direction(point, p)
        dist = distance(point, p)

        case Map.get(acc, dir) do
          d when is_nil(d) or d > dist -> Map.put(acc, dir, {dist, p})
          _ -> acc
        end
    end)
    # |> IO.inspect(label: :all)
    |> Map.keys()
    |> Enum.count()
  end

  # slope ain't gonna cut it
  defp direction({xf, yf} = from, {xt, yt} = to) do
    y = yt - yf
    x = xt - xf
    # if from == {3, 4}, do: IO.inspect({y, x, to}, label: :direction)
    Math.atan2(y, x)
  end

  # not super important to calculate these distances so accurately
  # we could use manhattan distance here
  defp distance({xf, yf} = to, {xt, yt} = from) do
    (:math.pow(xf - xt, 2) + :math.pow(yf - yt, 2)) |> :math.sqrt()
  end
end

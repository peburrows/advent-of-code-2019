defmodule Advent19.Day08 do
  def part1(input) do
    {layer, digits, _count} =
      input
      |> setup_input
      |> fewest_zeros

    count_digits(digits, 1) * count_digits(digits, 2)
  end

  def part2(input) do
    all =
      input
      |> setup_input
      |> render({0, 0, %{}})
      |> to_screen({0, 0})
  end

  defp to_screen(_output, {x, y}) when x > 5, do: nil

  defp to_screen(output, {x, y}) do
    case Map.get(output, {x, y}) do
      0 ->
        IO.write("X")

      _ ->
        IO.write(" ")
    end

    {x, y} =
      case {x, y} do
        {x, y} when y == 24 ->
          IO.write("\n")
          {x + 1, 0}

        {x, y} ->
          {x, y + 1}
      end

    to_screen(output, {x, y})
  end

  defp render([], {_, _, acc}), do: acc

  defp render([layer | rest], acc) do
    render(rest, render_one(layer, acc))
  end

  defp render_one([], {_, _, acc}), do: {0, 0, acc}

  defp render_one([pixel | rest], {x, y, acc}) do
    {x, y} =
      case {x, y} do
        {x, y} when y == 24 -> {x + 1, 0}
        {x, y} -> {x, y + 1}
      end

    acc =
      case pixel do
        0 -> Map.put_new(acc, {x, y}, 0)
        1 -> Map.put_new(acc, {x, y}, 1)
        _ -> acc
      end

    render_one(rest, {x, y, acc})
  end

  defp fewest_zeros(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce({nil, nil, nil}, fn {pixels, layer}, {f_index, f_pixels, f_count} ->
      pixels
      |> count_digits(0)
      |> case do
        c when is_nil(f_count) -> {layer, pixels, c}
        c when c < f_count -> {layer, pixels, c}
        _ -> {f_index, f_pixels, f_count}
      end
    end)
  end

  defp setup_input(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk(25 * 6)
  end

  defp count_digits(pixels, digit), do: Enum.count(pixels, fn p -> p == digit end)
end

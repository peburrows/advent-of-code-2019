defmodule Advent19.Day07 do
  alias Advent19.IntCode

  def part1(code) do
    # this is a terrible way to generate these phases...
    phases = generate_phases(0, 4)

    # now find the largest
    Enum.reduce(phases, {0, nil}, fn phase, {max, found} ->
      result = run_amplifiers(code, phase)
      if result > max, do: {result, phase}, else: {max, found}
    end)
  end

  def generate_phases(start, finish) do
    Enum.flat_map(start..finish, fn a ->
      Enum.flat_map(start..finish, fn b ->
        Enum.flat_map(start..finish, fn c ->
          Enum.flat_map(start..finish, fn d ->
            Enum.map(start..finish, fn e ->
              [a, b, c, d, e]
            end)
          end)
        end)
      end)
    end)
    |> Enum.filter(fn list ->
      if MapSet.new(list) |> MapSet.size() < length(list), do: false, else: true
    end)
  end

  defp unique_phases(curr, count \\ 5) do
    # basically, if the number isn't already in the
    Enum.reduce(0..(count - 1), curr, fn i, acc ->
      nil
    end)
  end

  def run_amplifiers(code, phases) do
    # eventually make this faster by compiling only once
    # compiled = IntCode.State.compile(code,[])
    {output, _} =
      Enum.reduce(0..(length(phases) - 1), {0, phases}, fn _i, {input, [p | phases]} ->
        output = IntCode.run(code, [p, input]) |> IntCode.output()
        {output, phases}
      end)

    output
  end

  def part2 do
  end
end

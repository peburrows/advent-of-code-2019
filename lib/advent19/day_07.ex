defmodule Advent19.Day07 do
  alias Advent19.IntCode

  def part1(code), do: find_largest(code, 0, 4)
  def part2(code), do: find_largest(code, 5, 9)

  def find_largest(code, start, finish) do
    generate_phases(start, finish)
    |> Enum.reduce({0, nil}, fn phase, {max, found} ->
      result = run_looped_amplifiers(code, phase)
      if result > max, do: {result, phase}, else: {max, found}
    end)
  end

  def run_looped_amplifiers(code, phases) do
    amp_a =
      phases
      |> Enum.reverse()
      |> Enum.reduce(self(), fn phase, next ->
        Process.spawn(
          IntCode,
          :run,
          [
            code,
            [phase],
            # input func - wait for input from the previous amp
            fn ->
              receive do
                msg -> msg
              end
            end,
            # output func - just send the output to the next amp
            fn state, out ->
              send(next, out)
              state
            end
          ],
          []
        )
      end)

    send(amp_a, 0)
    listen(amp_a)
  end

  defp listen(pid) do
    # when we get a message from amp_e, we need to send it back into amp_a
    receive do
      result ->
        if Process.alive?(pid) do
          send(pid, result)
          listen(pid)
        else
          result
        end
    end
  end

  def part2 do
  end

  defp generate_phases(start, finish) do
    start..finish
    |> Enum.into([])
    |> do_generate_phases
  end

  defp do_generate_phases([]), do: [[]]

  defp do_generate_phases(list),
    do: for(elem <- list, rest <- do_generate_phases(list -- [elem]), do: [elem | rest])
end

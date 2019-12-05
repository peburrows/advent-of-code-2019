defmodule Advent19.Day05 do
  defmodule State do
    defstruct instructions: [],
              values: %{},
              input: nil,
              index: 0,
              complete: false,
              output: []
  end

  def part1(program, input \\ nil)

  def part1(program, input) when is_binary(program) do
    program
    |> Advent19.Utils.Input.csv_to_ints()
    |> part1(input)
  end

  def part1(nums, input) do
    input =
      case input do
        nil -> nil
        val -> val |> to_string |> String.to_integer()
      end

    state = %State{instructions: nums, input: input}

    values =
      state.instructions
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {v, i}, acc ->
        Map.put(acc, i, v)
      end)

    %{state | values: values}
    |> do_part1
  end

  def result(%{values: v}), do: Map.values(v)
  def output(%{output: o}), do: Enum.reverse(o) |> Enum.join("")

  defp do_part1(%{values: v, index: i} = state) do
    v
    |> Map.get(i)
    |> calculate(state)
    |> case do
      %{complete: true} = state -> state
      state -> do_part1(state)
    end
  end

  # extract the mode from the instructions
  defp calculate(code, state) do
    {op, m1, m2, m3} = extract_modes(code)
    calculate(op, {m1, m2, m3}, state)
  end

  defp calculate(99, _mode, %{index: i} = state), do: %{state | complete: true, index: i + 1}

  defp calculate(1, {m1, m2, _}, %{values: v, index: i} = state) do
    {a, b} = {extract_ref(v, i + 1, m1), extract_ref(v, i + 2, m2)}
    dest = Map.get(v, i + 3)
    %{state | values: Map.put(v, dest, a + b), index: i + 4}
  end

  defp calculate(2, {m1, m2, _}, %{values: v, index: i} = state) do
    {a, b} = {extract_ref(v, i + 1, m1), extract_ref(v, i + 2, m2)}
    dest = Map.get(v, i + 3)
    %{state | values: Map.put(v, dest, a * b), index: i + 4}
  end

  defp calculate(3, {m1, _, _}, %{values: v, index: i, input: input} = state) do
    dest = Map.get(v, i + 1, m1)
    %{state | index: i + 2, values: Map.put(v, dest, input)}
  end

  defp calculate(4, {m1, _, _}, %{values: v, index: i, output: out} = state) do
    val = extract_ref(v, i + 1, m1)
    %{state | index: i + 2, output: [val | out]}
  end

  defp calculate(_other, _mode, %{index: i} = state), do: %{state | complete: true, index: i + 1}

  defp extract_modes(code) do
    digits =
      code
      |> Integer.digits()
      |> Enum.reverse()

    op =
      ((Enum.at(digits, 1, 0) |> to_string) <> (Enum.at(digits, 0) |> to_string))
      |> String.to_integer()

    {
      op,
      Enum.at(digits, 2, 0),
      Enum.at(digits, 3, 0),
      Enum.at(digits, 4, 0)
    }
  end

  defp extract_ref(values, i, 0) do
    ai = Map.get(values, i)
    Map.get(values, ai)
  end

  defp extract_ref(values, i, 1),
    do: Map.get(values, i)
end
defmodule Advent19.IntCode do
  defmodule State do
    defstruct code: [],
              values: %{},
              inputs: [],
              index: 0,
              complete: false,
              output: []

    def compile(code, inputs) do
      values =
        code
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {v, i}, acc ->
          Map.put(acc, i, v)
        end)

      %__MODULE__{
        values: values,
        code: code,
        inputs: inputs
      }
    end
  end

  # eventually extract these into the compiler
  def run(code, inputs \\ [])

  def run(code, inputs) when is_binary(code) do
    code
    |> Advent19.Utils.Input.csv_to_ints()
    |> run(inputs)
  end

  def run(code, inputs) when is_binary(inputs) do
    inputs = String.split(",", trim: true)
    run(code, inputs)
  end

  def run(code, inputs) when is_integer(inputs), do: run(code, [inputs])

  def run(code, inputs) do
    code
    |> State.compile(inputs)
    |> do_run
  end

  defp do_run(%State{values: values, index: index} = state) do
    values
    |> Map.get(index)
    |> process_instruction(state)
    |> case do
      %{complete: true} = state -> state
      state -> do_run(state)
    end
  end

  def result(%{values: v}), do: Map.values(v)
  def output(%{output: o}), do: Enum.reverse(o) |> List.first()

  # extract the mode from the instructions
  defp process_instruction(code, state) do
    {op, m1, m2, m3} = extract_modes(code)
    process_instruction(op, {m1, m2, m3}, state)
  end

  defp process_instruction(99, _mode, %{index: i} = state),
    do: %{state | complete: true, index: i + 1}

  defp process_instruction(1, {m1, m2, _}, %{values: v, index: i} = state) do
    {a, b} = {extract_ref(v, i + 1, m1), extract_ref(v, i + 2, m2)}
    dest = Map.get(v, i + 3)
    %{state | values: Map.put(v, dest, a + b), index: i + 4}
  end

  defp process_instruction(2, {m1, m2, _}, %{values: v, index: i} = state) do
    {a, b} = {extract_ref(v, i + 1, m1), extract_ref(v, i + 2, m2)}
    dest = Map.get(v, i + 3)
    %{state | values: Map.put(v, dest, a * b), index: i + 4}
  end

  defp process_instruction(3, {m1, _, _}, %{values: v, index: i, inputs: [input | rest]} = state) do
    dest = Map.get(v, i + 1, m1)
    %{state | index: i + 2, values: Map.put(v, dest, input), inputs: rest}
  end

  defp process_instruction(4, {m1, _, _}, %{values: v, index: i, output: out} = state) do
    val = extract_ref(v, i + 1, m1)
    %{state | index: i + 2, output: [val | out]}
  end

  defp process_instruction(5, {m1, m2, _}, %{values: v, index: i} = state) do
    # jump-if-true
    i =
      case extract_ref(v, i + 1, m1) do
        0 -> i + 3
        _ -> extract_ref(v, i + 2, m2)
      end

    %{state | index: i}
  end

  defp process_instruction(6, {m1, m2, _}, %{values: v, index: i} = state) do
    # jump-if-false
    i =
      case extract_ref(v, i + 1, m1) do
        0 -> extract_ref(v, i + 2, m2)
        _ -> i + 3
      end

    %{state | index: i}
  end

  # Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  defp process_instruction(7, {m1, m2, _m3}, %{values: v, index: i} = state) do
    a = extract_ref(v, i + 1, m1)
    b = extract_ref(v, i + 2, m2)
    dest = extract_ref(v, i + 3, 1)
    val = if a < b, do: 1, else: 0

    %{state | values: Map.put(v, dest, val), index: i + 4}
  end

  # Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  defp process_instruction(8, {m1, m2, _m3}, %{values: v, index: i} = state) do
    a = extract_ref(v, i + 1, m1)
    b = extract_ref(v, i + 2, m2)
    dest = extract_ref(v, i + 3, 1)
    val = if a == b, do: 1, else: 0

    %{state | values: Map.put(v, dest, val), index: i + 4}
  end

  defp process_instruction(_other, _mode, %{index: i} = state),
    do: %{state | complete: true, index: i + 1}

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

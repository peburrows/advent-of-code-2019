defmodule Advent19.IntCode do
  defmodule State do
    defstruct code: [],
              values: %{},
              inputs: [],
              input_func: nil,
              index: 0,
              relative_base: 0,
              complete: false,
              output: [],
              output_func: nil,
              halted: false

    def default_output_function(state, out) do
      # IO.puts("outputing! #{inspect(out)}")
      %{state | output: [out | state.output]}
    end

    def compile(%__MODULE__{} = compiled, inputs) do
      %{compiled | inputs: inputs}
    end

    def compile(code, inputs, input_func \\ nil, output_func \\ &default_output_function/2) do
      values =
        code
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {v, i}, acc ->
          Map.put(acc, i, v)
        end)

      %__MODULE__{
        values: values,
        code: code,
        inputs: inputs,
        output_func: output_func,
        input_func: input_func
      }
    end
  end

  defdelegate compile(code, inputs), to: State

  @ops %{
    1 => :add,
    2 => :multiply,
    3 => :input,
    4 => :output,
    5 => :jump_if_true,
    6 => :jump_if_false,
    7 => :less_than,
    8 => :equal,
    9 => :adjust_relative_base,
    99 => :exit
  }
  # eventually extract these into the compiler
  def run(code, inputs \\ [], input_func \\ nil, output_func \\ &State.default_output_function/2)

  def run(code, inputs, input_func, output_func) when is_binary(code) do
    code
    |> Advent19.Utils.Input.csv_to_ints()
    |> run(inputs, input_func, output_func)
  end

  def run(code, inputs, input_func, output_func) when is_binary(inputs) do
    inputs = String.split(inputs, ",", trim: true)
    run(code, inputs, input_func, output_func)
  end

  def run(code, inputs, input_func, output_func) when is_integer(inputs),
    do: run(code, [inputs], input_func, output_func)

  def run(code, inputs, input_func, output_func) do
    code
    |> State.compile(inputs, input_func, output_func)
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
  def output(%{output: _o} = state), do: state |> full_output |> List.first()
  def full_output(%{output: o}), do: Enum.reverse(o)

  # extract the mode from the instructions
  defp process_instruction(code, state) do
    {op, m1, m2, m3} = extract_modes(code)
    process_instruction(op, {m1, m2, m3}, state)
  end

  defp process_instruction(:exit, _mode, %{index: i} = state),
    do: %{state | complete: true, halted: true, index: i + 1}

  defp process_instruction(:add, {m1, m2, m3}, %{values: v, index: i} = state) do
    {a, b} = {extract_ref(state, i + 1, m1), extract_ref(state, i + 2, m2)}
    # dest = Map.get(v, i + 3)
    # dest = extract_ref(state, i + 3, dest_mode(m3))
    dest = get_dest(state, i + 3, m3)
    %{state | values: Map.put(v, dest, a + b), index: i + 4}
  end

  defp process_instruction(:multiply, {m1, m2, m3}, %{values: v, index: i} = state) do
    {a, b} = {extract_ref(state, i + 1, m1), extract_ref(state, i + 2, m2)}
    # dest = Map.get(v, i + 3)
    # dest = extract_ref(state, i + 3, dest_mode(m3))
    dest = get_dest(state, i + 3, m3)
    %{state | values: Map.put(v, dest, a * b), index: i + 4}
  end

  # inputs!
  defp process_instruction(
         :input,
         {m1, _, _},
         %{values: v, index: i, inputs: [input | rest]} = state
       ) do
    # IO.puts("input, I guess #{m1}")
    # dest = Map.get(v, i + 1, dest_mode(m1))
    # dest = extract_ref(state, i + 1, dest_mode(m1))
    dest = get_dest(state, i + 1, m1)
    %{state | index: i + 2, values: Map.put(v, dest, input), inputs: rest}
  end

  defp process_instruction(:input, {_, _, _}, %{input_func: nil} = state) do
    # IO.puts("needed input, but got none!")
    :ok = false
    %{state | complete: true, halted: true}
  end

  defp process_instruction(:input, {m1, _, _}, %{values: v, index: i, input_func: f} = state) do
    # dest = extract_ref(state, i + 1, dest_mode(m1))
    dest = get_dest(state, i + 1, m1)
    %{state | index: i + 2, values: Map.put(v, dest, f.())}
  end

  defp process_instruction(:output, {m1, _, _}, %{index: i, output_func: out} = state) do
    val = extract_ref(state, i + 1, m1)
    state = out.(state, val)
    %{state | index: i + 2}
  end

  defp process_instruction(:jump_if_true, {m1, m2, _}, %{values: v, index: i} = state) do
    # jump-if-true
    i =
      case extract_ref(state, i + 1, m1) do
        0 -> i + 3
        _ -> extract_ref(state, i + 2, m2)
      end

    %{state | index: i}
  end

  defp process_instruction(:jump_if_false, {m1, m2, _}, %{values: v, index: i} = state) do
    # jump-if-false
    i =
      case extract_ref(state, i + 1, m1) do
        0 -> extract_ref(state, i + 2, m2)
        _ -> i + 3
      end

    %{state | index: i}
  end

  # Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  defp process_instruction(:less_than, {m1, m2, m3}, %{values: v, index: i} = state) do
    a = extract_ref(state, i + 1, m1)
    b = extract_ref(state, i + 2, m2)
    # I maybe this should fallback to 1 if mode is ... 0?
    # dest = extract_ref(state, i + 3, dest_mode(m3))
    dest = get_dest(state, i + 3, m3)
    val = if a < b, do: 1, else: 0

    %{state | values: Map.put(v, dest, val), index: i + 4}
  end

  # Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  defp process_instruction(:equal, {m1, m2, m3}, %{values: v, index: i} = state) do
    a = extract_ref(state, i + 1, m1)
    b = extract_ref(state, i + 2, m2)
    # dest = extract_ref(state, i + 3, dest_mode(m3))
    dest = get_dest(state, i + 3, m3)
    val = if a == b, do: 1, else: 0

    %{state | values: Map.put(v, dest, val), index: i + 4}
  end

  defp process_instruction(
         :adjust_relative_base,
         {m1, _, _},
         %{relative_base: base, index: i} = state
       ) do
    a = extract_ref(state, i + 1, m1)
    %{state | relative_base: max(base + a, 0), index: i + 2}
  end

  defp process_instruction({:not_found, _op}, _mode, %{index: i} = state) do
    %{state | complete: true, index: i + 1}
  end

  defp extract_modes(code) do
    digits =
      code
      |> Integer.digits()
      |> Enum.reverse()

    op =
      ((Enum.at(digits, 1, 0) |> to_string) <> (Enum.at(digits, 0) |> to_string))
      |> String.to_integer()

    {
      Map.get(@ops, op, {:not_found, op}),
      Enum.at(digits, 2, 0) |> mode,
      Enum.at(digits, 3, 0) |> mode,
      Enum.at(digits, 4, 0) |> mode
    }
  end

  defp mode(0), do: :position
  defp mode(1), do: :immediate
  defp mode(2), do: :relative

  # position mode
  defp extract_ref(%{values: values}, i, :position) do
    ai = Map.get(values, i)
    Map.get(values, ai, 0)
  end

  # immediate mode
  defp extract_ref(%{values: values}, i, :immediate) do
    # IO.puts("immediate: #{i}")
    Map.get(values, i, 0)
  end

  # relative mode
  defp extract_ref(%{values: values, relative_base: base} = state, i, :relative) do
    # IO.puts("pulling from a relative base, I guess? #{i} :: #{base}")

    # should this ever default to zero...?
    iv = Map.get(values, i)
    Map.get(values, iv + base, 0)
  end

  defp get_dest(%{values: v, relative_base: base} = state, i, mode) do
    case mode do
      :immediate -> Map.get(v, i, 0)
      :position -> Map.get(v, i, 0)
      :relative -> Map.get(v, i, 0) + base
    end
  end
end

defmodule Mix.Tasks.Day.Run do
  use Mix.Task

  def run([day, part]) do
    Application.ensure_all_started(:advent19)

    day
    |> Advent19.Utils.Input.read()
    |> run_part(day, part)
    |> IO.inspect(label: :output)
  end

  defp run_part(input, day, part) do
    mod = :"Elixir.Advent19.Day#{padded_day(day)}"
    func = :"part#{part}"

    apply(mod, func, [input])
  end

  defp padded_day(day) do
    day
    |> to_string
    |> String.pad_leading(2, "0")
  end
end

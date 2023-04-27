defmodule Mix.Tasks.Type do
  use Mix.Task

  require Logger

  def run([]) do
    prepare()
    check()
  end

  # `mix type Enum` for single module
  # `mix type Enum.map` for single function
  # `mix type Enum.map/2` for single function with specified arity
  def run([filter]) when is_binary(filter) do
    prepare()

    filter = ExType.Filter.parse(filter)
    ExType.Filter.register(filter)

    check()
  end

  defp prepare() do
    Mix.Task.run("compile", [])
    Mix.Task.run("loadpaths", [])
  end

  defp check() do
    # could run in parallel
    for file <- get_files() do
      Logger.info("Checking #{file}")
      ExType.check(file)
    end
  end

  defp get_files() do
    cwd = File.cwd!()

    type_exs = Path.join(cwd, "type.exs")

    config =
      if File.exists?(type_exs) do
        type_exs
        |> Code.eval_file()
        |> elem(0)
      else
        []
      end
    Logger.debug("""
      Config from type.exs:
      #{inspect(config)}
    """)

    if Keyword.get(config, :debug, false) do
      ExType.Debug.set()
    end

    includes =
      Keyword.get(config, :include, ["lib/**/*.ex"])
      |> Enum.flat_map(fn glob -> Path.wildcard(Path.join(cwd, glob)) end)
      |> Enum.into(MapSet.new())

      Logger.debug("""
      includes:
      #{inspect(includes)}
    """)

    excludes =
      Keyword.get(config, :exclude, [])
      |> Enum.flat_map(fn glob -> Path.wildcard(Path.join(cwd, glob)) end)
      |> Enum.into(MapSet.new())

    Logger.debug("""
      excludes:
      #{inspect(excludes)}
    """)

    MapSet.difference(includes, excludes)
  end
end

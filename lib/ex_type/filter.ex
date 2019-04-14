defmodule ExType.Filter do
  @moduledoc false

  # Support mix type.only

  use ExType.Helper

  def register_filter(file, filter) do
    :persistent_term.put({ExType, file}, filter)
  end

  def need_process?(file, module, name, arity) do
    filter =
      try do
        :persistent_term.get({ExType, file})
      rescue
        ArgumentError -> fn _ -> true end
      end

    filter.({module, name, arity})
  end

  def parse(name) do
    name
    |> Code.string_to_quoted!()
    |> :elixir_expand.expand(__ENV__)
    |> elem(0)
    |> case do
      # check single function with specified arity
      {{:., _, [:erlang, :/]}, _, [{{:., _, [module, method]}, _, []}, arity]} ->
        fn
          {^module, ^method, ^arity} -> true
          _ -> false
        end

      # check single function
      {{:., _, [module, method]}, _, _} ->
        fn
          {^module, ^method, _arity} -> true
          _ -> false
        end

      # check single module
      module when is_atom(module) ->
        fn
          {^module, _method, _arity} -> true
          _ -> false
        end
    end
  end
end
defmodule ExType.Example.Foo do
  use T

  @spec hello() :: any()

  def hello() do
    %{1 => 2, 3 => 4}
    |> Enum.map(fn {a, b} ->
      a + b
    end)
    |> Enum.flat_map(fn k ->
      [k, k]
    end)
    |> Enum.reduce(1, fn x, y ->
      x + y
    end)
  end

  @spec for_expr() :: any()

  def for_expr() do
    for x <- [1, 2, 3] do
      x + 1
    end
  end
end

defmodule ExType.EnumerableTestCase do
  use T

  @spec hi() :: any()

  def hi() do
    T.assert(1 == integer())
  end
end

defmodule TypeChecks.Functions do
  @spec incrementor(number) :: (number -> number)
  def incrementor(x) do
    # fn y -> y + x end
    &(&1 + x)
    :bar
  end
end

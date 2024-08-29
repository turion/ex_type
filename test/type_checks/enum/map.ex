defmodule TypeChecks.Enum.Map do
  @spec add_one(Enum.t()) :: Enum.t()
  def add_one(enum) do
    # Enum.map(enum, fn x -> x + 1 end)
    # Enum.map(enum, &(&1 + 1))
    enum
  end
end

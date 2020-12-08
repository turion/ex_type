defmodule TypeChecks.CheckerTestCase do
  # See https://github.com/gyson/ex_type/issues/47
  _currently_failing_tests = """
  @spec test_case_1({:ok, integer()} | :error) :: any()

  def test_case_1(input) do
    case input do
      {:ok, x} ->
        T.assert(x == integer())
        x

      error ->
        T.assert(error == :error)
        error
    end
  end

  @spec test_case_2(:ok | integer()) :: integer()

  def test_case_2(input) do
    case input do
      :ok ->
        123

      x when x > 10 ->
        T.assert(x == integer())
        x

      other ->
        T.assert(other == integer())
        other
    end
  end
  """

  @spec identity_int(integer()) :: integer()
  def identity_int(x) do
    x
  end

  # Regression test for https://github.com/gyson/ex_type/issues/23
  defmodule Nested do
    @enforce_keys [:nested]
    defstruct @enforce_keys

    @type t(nested) :: %Nested{
      nested: nested
    }
  end

  # FIXME Would be great to have your input how you want to name test cases :)
  @spec get_nested(Nested.t(nested)) :: nested when nested: any()

  def get_nested(%Nested{nested: nested}) do
    nested
  end

  @spec function_with_send() :: :foo

  def function_with_send() do
    send(self(), "hi")
    :foo
  end
end

defmodule ExTypeTest do
  use ExUnit.Case
  doctest ExType

  for file <- Path.wildcard("#{__DIR__}/ex_type/**/*_test_case.ex") do
    test "#{file}" do
      IO.inspect(unquote(file))
      ExType.check(unquote(file))
      |> IO.inspect()
    end
  end

  for file <- Path.wildcard("#{__DIR__}/ex_type/**/*_failure_case.ex") do
    test "#{file}" do
      IO.inspect(unquote(file))
      ExType.check(unquote(file))
      |> IO.inspect()
    end
  end
end

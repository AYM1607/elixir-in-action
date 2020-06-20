defmodule ListHelper do
  def list_len([]), do: 0

  def list_len([_ | tail]) do
    1 + list_len(tail)
  end

  def range(num, num), do: [num]

  def range(num1, num2) do
    [num1 | range(num1 + 1, num2)]
  end

  def positive([]), do: []

  def positive([head | tail]) when head > 0 do
    [head | positive(tail)]
  end

  def positive([_ | tail]), do: positive(tail)
end

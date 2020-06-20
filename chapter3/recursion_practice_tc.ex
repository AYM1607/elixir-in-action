defmodule ListHelper do
  def list_len(list) do
    list_len_helper(0, list)
  end

  defp list_len_helper(current_len, []), do: current_len

  defp list_len_helper(current_len, [_ | tail]) do
    list_len_helper(current_len + 1, tail)
  end

  def range(num1, num2), do: range_helper([], num1, num2)

  defp range_helper(current_list, num, num), do: [num | current_list]

  defp range_helper(current_list, num1, num2) do
    range_helper([num2 | current_list], num1, num2 - 1)
  end

  def positive(list) do
    Enum.reverse(positive_helper([], list))
  end

  defp positive_helper(current_list, []), do: current_list

  defp positive_helper(current_list, [head | tail]) when head > 0 do
    positive_helper([head | current_list], tail)
  end

  defp positive_helper(current_list, [_ | tail]) do
    positive_helper(current_list, tail)
  end
end

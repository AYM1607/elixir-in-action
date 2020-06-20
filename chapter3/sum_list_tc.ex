defmodule ListHelper do
  def sum(list) do
    do_sum(0, list)
  end

  defp do_sum(current_sum, []) do
    current_sum
  end

  defp do_sum(current_sum, [head | tail]) do
    # More concise implementation
    # do_sum(current_sum + head, tail)
    new_sum = head + current_sum
    do_sum(new_sum, tail)
  end
end

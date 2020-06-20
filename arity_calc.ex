defmodule CalcOne do
  def sum(a) do
    sum(a, 0)
  end

  def sum(a, b) do
    a + b
  end
end

defmodule CalcTwo do
  def sum(a, b \\ 0) do
    a + b
  end
end

defmodule CalcThree do
  def fun(a, b, c \\ 0, d, e \\ 0) do
    a + b + c + d + e
  end
end

defmodule Geometry do
  def rectangle_area(a, b) do
    a * b
  end

  def rectangle_area_condensed(a, b), do: a * b
end

defmodule Rectangle do
  def area(a, b), do: a * b
  def area(a), do: area(a, a)
end

defmodule GeometryMultiClause do
  def area({:rectangle, a, b}) do
    a * b
  end

  def area({:square, a}) do
    a * a
  end

  def area({:circle, r}) do
    r * r * 3.14159
  end

  def area(unknown) do
    {:error, {:unkown_shape, unknown}}
  end
end

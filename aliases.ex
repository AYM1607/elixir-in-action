defmodule Some.Nested do
  def print_from_nested do
    IO.puts("Somehting from nested")
  end
end

defmodule MyModule do
  import IO
  alias IO, as: MyIO
  alias Some.Nested

  def print do
    puts("Something")
  end

  def print_from_alias do
    MyIO.puts("Something from alias")
  end

  def print_from_nested, do: Nested.print_from_nested()
end

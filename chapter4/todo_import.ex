defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, todo_list_acc ->
        add_entry(todo_list_acc, entry)
      end
      # Alternative definition
      # &add_entry(&2, &1)
    )
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries =
      Map.put(
        todo_list.entries,
        todo_list.auto_id,
        entry
      )

    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        # Make sure that the result of the updater is a map and the
        # id remains unchanged.
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    %TodoList{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end
end

defmodule TodoList.CsvImporter do
  def import(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(fn string ->
      [date, title] = String.split(string, ",")
      {date, title}
    end)
    |> Stream.map(fn {date, title} ->
      [year, month, day] =
        date
        |> String.split("/")
        |> Enum.map(&String.to_integer(&1))

      {{year, month, day}, title}
    end)
    |> Stream.map(fn {{year, month, day}, title} ->
      {:ok, date} = Date.new(year, month, day)
      %{date: date, title: title}
    end)
    |> TodoList.new()
  end
end

defmodule TodoList.CsvImporterAlternative do
  def import(path) do
    path
    |> read_lines
    |> create_entires
    |> TodoList.new()
  end

  defp read_lines(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  defp create_entires(lines) do
    lines
    |> Stream.map(&extract_fileds/1)
    |> Stream.map(&create_entry/1)
  end

  defp extract_fileds(line) do
    line
    |> String.split(",")
    |> convert_date
  end

  defp convert_date([date_string, title]) do
    {parse_date(date_string), title}
  end

  defp parse_date(date_string) do
    [year, month, day] =
      date_string
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)

    {:ok, date = Date.new(year, month, day)}
    date
  end

  defp create_entry({date, title}) do
    %{date: date, title: title}
  end
end

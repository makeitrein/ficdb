defmodule Ficdb.EnumHelpers do

  # atom is the type of EctoEnum enums
  def enum_keys(enum) when is_atom(enum), do: enum.__enum_map__() |> Keyword.keys

  # designed for those dropdowns that need a default selection at the beginning
  def with_default_option(list) when is_list(list), do: [{"Any", ""} | list]

  def remove_empty_entires(list), do: list |> Enum.reject(fn {_, v} -> v == "" end) |> Map.new

  def get_dropdown_tuple(list), do: list |> Enum.map(fn item -> {Phoenix.Naming.humanize(item.name), item.id} end)

  def push_nested_param(struct, key_path, val) do
    param_arr = get_in(struct, key_path) || []
    put_in(struct, Enum.map(key_path, &Access.key(&1, %{})), Enum.uniq(param_arr ++ [Integer.to_string val]))
  end

  def set_nested_param(struct, key_path, val) do
    put_in(struct, Enum.map(key_path, &Access.key(&1, %{})), val)
  end

  def include_bang(list) do
    list |> Enum.filter(fn item -> item.name |> String.contains?("!") end)
  end

  def exclude_bang(list) do
    list |> Enum.filter(fn item -> !(item.name |> String.contains?("!")) end)
  end

end

defmodule Ficdb.SchemaHelpers do
  import Ecto.Query
  alias Ficdb.Repo

  def pluck(list, prop), do: Enum.map(list, &Map.get(&1, prop))
  def fanfic_count_english(fanfic_count), do: Integer.to_string(fanfic_count) <> " " <> Inflex.inflect("work", fanfic_count)
  def fandoms_english(fandoms), do: fandoms |> pluck(:name) |>  Enum.join(" / ")

  def dropdown_format_query(query) do
    from g in query,
         select: {g.name, g.id}
  end

  def with_fanfics_query(query) do
    from g in query,
           join: fanfics in assoc(g, :fanfics),
           group_by: g.id,
           having: count(fanfics.id, :distinct) > 0
  end

  def selectize_format_query(query) do
    from g in query,
         select: %{text: g.name, value: g.id}
  end

  def ordered_by_query(query) do
    from g in query,
         order_by: [asc: :name]
  end

  def order_by_query(query, order_by) do
    from f in query,
         order_by: ^order_by
  end

  def schema_length(query) do
    Repo.aggregate(query, :count, :id)
  end
end
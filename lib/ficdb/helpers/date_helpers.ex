defmodule Ficdb.DateHelpers do
  use Timex
  alias Ficdb.Repo
  import Ecto.Query, only: [from: 2]

  def relative(datetime), do: datetime|>  Timex.format("{relative}", :relative) |> elem(1)

  def last_updated_at schema do
    query = from f in schema, select: max(f.updated_at)
    query |> Repo.all |> hd |> relative
  end

  def now_microseconds,
      do: Timex.to_gregorian_microseconds(Timex.now)
end
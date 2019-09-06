defmodule Ficdb.Directory.FanficsFandoms do
  use Ecto.Schema
  import Ecto.Changeset


  schema "fanfics_fandoms" do
    field :fandom_id, :id
    field :fanfic_id, :id
    field :submitter_id, :id
    field :updater_id, :id

    timestamps()
  end

  @doc false
  def changeset(fanfics_fandoms, attrs) do
    fanfics_fandoms
    |> cast(attrs, [])
    |> validate_required([])
  end
end

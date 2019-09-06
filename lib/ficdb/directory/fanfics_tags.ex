defmodule Ficdb.Directory.FanficsTags do
  use Ecto.Schema
  import Ecto.Changeset


  schema "fanfics_tags" do
    field :tag_id, :id
    field :fanfic_id, :id
    field :submitter_id, :id
    field :updater_id, :id

    timestamps()
  end

  @doc false
  def changeset(fanfics_tags, attrs) do
    fanfics_tags
    |> cast(attrs, [])
    |> validate_required([])
  end
end

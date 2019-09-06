defmodule Ficdb.Directory.PrimaryRelationship do
  use Ecto.Schema
  import Ecto.Changeset


  schema "primary_relationship" do
    field :character_id, :id
    field :fanfic_id, :id
    field :submitter_id, :id
    field :updater_id, :id

    timestamps()
  end

  @doc false
  def changeset(primary_relationship, attrs) do
    primary_relationship
    |> cast(attrs, [])
    |> validate_required([])
  end
end

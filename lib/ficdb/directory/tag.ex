defmodule Ficdb.Directory.Tag do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tags" do
    field :description, :string
    field :name, :string
    field :fandom_id, :id
    field :submitter_id, :id
    field :updater_id, :id

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end

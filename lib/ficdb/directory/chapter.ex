defmodule Ficdb.Directory.Chapter do
  use Ecto.Schema
  import Ecto.Changeset


  schema "chapters" do
    field :posted_at, :utc_datetime
    field :reactions, :integer
    field :url, :string
    field :fanfic_id, :id
    field :submitter_id, :id
    field :updater_id, :id
    field :sb_id, :integer
    field :ao3_id, :integer
    field :ff_id, :integer
    field :sv_id, :integer
    field :ah_id, :integer
    field :qq_id, :integer
    field :tb_id, :integer

    timestamps()
  end

  @doc false
  def changeset(chapter, attrs) do
    chapter
    |> cast(
         attrs,
         [
           :url,
           :posted_at,
           :reactions,
           :sb_id,
           :ao3_id,
           :ff_id,
           :ah_id,
           :qq_id,
           :tb_id
         ]
       )
    |> validate_required([:posted_at])
  end
end

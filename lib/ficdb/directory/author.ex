defmodule Ficdb.Directory.Author do
  use Ecto.Schema
  import Ecto.Changeset


  schema "authors" do
    field :name, :string
    field :urls, {:array, :string}
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
  def changeset(author, attrs) do
    author
    |> cast(
         attrs,
         [
           :name,
           :urls,
           :sb_id,
           :ao3_id,
           :ff_id,
           :ah_id,
           :qq_id,
           :tb_id,
           :submitter_id,
           :updater_id,
         ]
       )
    |> validate_required([:name])
  end
end

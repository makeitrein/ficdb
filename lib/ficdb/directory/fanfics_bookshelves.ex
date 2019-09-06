defmodule Ficdb.Directory.FanficsBookshelves do
  use Ecto.Schema
  import Ecto.Changeset


  schema "fanfics_bookshelves" do
    field :submitter_id, :id
    field :updater_id, :id

    belongs_to :bookshelf, Ficdb.Directory.Bookshelf
    belongs_to :fanfic, Ficdb.Directory.Fanfic


    timestamps()
  end

  @doc false
  def changeset(fanfics_bookshelves, attrs) do
    fanfics_bookshelves
    |> cast(attrs, [:submitter_id, :updater_id, :bookshelf_id, :fanfic_id])
    |> validate_required([:submitter_id, :bookshelf_id, :fanfic_id])
  end
end

defmodule Ficdb.Directory.FanficsGenres do
  use Ecto.Schema
  import Ecto.Changeset


  schema "fanfics_genres" do
    field :fanfic_id, :id, null: false
    field :genre_id, :id, null: false
    field :submitter_id, :id
    field :updater_id, :id

    timestamps()
  end

end

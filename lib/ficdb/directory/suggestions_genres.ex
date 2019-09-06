defmodule Ficdb.Directory.SuggestionsGenres do
  use Ecto.Schema
  import Ecto.Changeset


  schema "suggestions_genres" do
    field :suggestion_id, :id, null: false
    field :genre_id, :id, null: false
    field :submitter_id, :id
    field :updater_id, :id

    timestamps()
  end

end

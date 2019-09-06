defmodule Ficdb.Directory.Suggestion do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query


  schema "suggestions" do
    field :content, :string
    belongs_to :fanfic, Ficdb.Directory.Fanfic
    belongs_to :submitter, Ficdb.Veil.User
    field :updater_id, :id
    many_to_many :genres, Ficdb.Directory.Genre, join_through: Ficdb.Directory.SuggestionsGenres, on_replace: :delete

    timestamps()
  end

  def summary_query(query) do
    from r in query,
         preload: [
           :submitter,
            :genres
         ]
  end

  def list_query(query) do
    from r in query,
         preload: [
           :submitter,
           :fanfic,
            :genres
         ],
        order_by: [{:desc, :updated_at}]
  end

  def get_genres (ids) do
    (ids || [])
    |> Enum.map(&Ficdb.Directory.get_genre!/1)
  end

  @doc false
  def changeset(suggestion, attrs) do
    suggestion
    |> cast(attrs, [:content, :submitter_id, :fanfic_id])
    |> validate_required([:content, :submitter_id])
    |> put_assoc(:genres, get_genres(attrs["genres"]))
  end
end

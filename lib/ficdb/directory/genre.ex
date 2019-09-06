defmodule Ficdb.Directory.Genre do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query
  alias Ficdb.FilenameRandomizer

  schema "genres" do
    field :description, :string
    field :image, Ficdb.Image.Type
    field :name, :string
    field :fanfic_count, :integer, virtual: true, default: 0
    field :genre_type, Ficdb.GenreEnum

    belongs_to :fandom, Ficdb.Directory.Fandom
    belongs_to :submitter, Ficdb.Veil.User
    belongs_to :updater, Ficdb.Veil.User

    many_to_many :fanfics, Ficdb.Directory.Fanfic, join_through: Ficdb.Directory.FanficsGenres
    has_many :fanfics_genres, Ficdb.Directory.FanficsGenres, on_delete: :delete_all

    timestamps()
  end

  def with_fanfic_count_query(query) do
    from g in query,
      left_join: f in assoc(g, :fanfics),
      group_by: g.id,
      select: %{g | fanfic_count: count(f.id)}
  end

  def with_fandom_query(query) do
    from f in query,
         preload: [
           :fandom
         ]
  end

  def json_query(query) do
    from g in query,
      select: map(g, [:id, :name, :genre_type])
  end

  @doc false
  def changeset(genre, attrs) do
    attrs = FilenameRandomizer.put_random_filename attrs
    genre
    |> cast(attrs, [:name, :description, :genre_type, :submitter_id, :updater_id, :genre_type, :fandom_id])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

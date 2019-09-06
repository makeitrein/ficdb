defmodule Ficdb.Directory.Fandom do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  use Arc.Ecto.Schema
  alias Ficdb.FilenameRandomizer
  alias Ficdb.Directory
  alias Ficdb.Directory.Character

  schema "fandoms" do
    field :author, :string
    field :description, :string
    field :name, :string
    field :url, :string
    field :fanfic_count, :integer, virtual: true, default: 0
    field :image, Ficdb.Image.Type
    field :fandom_type, Ficdb.FandomEnum
    belongs_to :submitter, Ficdb.Veil.User
    belongs_to :updater, Ficdb.Veil.User
    has_many :characters, Ficdb.Directory.Character, on_replace: :delete
    many_to_many :fanfics, Ficdb.Directory.Fanfic, join_through: Ficdb.Directory.FanficsFandoms, on_replace: :delete

    timestamps()
  end

  def with_fanfic_count_query(query) do
    from g in query,
         left_join: f in assoc(g, :fanfics),
         group_by: g.id,
         select: %{g | fanfic_count: count(f.id)}
  end

  def json_query(query) do
    from g in query,
         select: map(g, [:id, :name, :fandom_type])
  end

  def remove_invalid_characters(attrs) do
    if (character_params = attrs["characters"]) do
      valid_characters = character_params |> Enum.filter(fn {_k,character} -> Character.changeset(%Character{}, character).valid? end) |> Map.new
      %{attrs | "characters" => valid_characters}
    else
      attrs
    end
  end


  @doc false
  def changeset(fandom, attrs) do
    attrs = attrs |> remove_invalid_characters |> FilenameRandomizer.put_random_filename
    fandom
    |> cast(attrs, [:url, :name, :author, :description, :fandom_type])
    |> cast_attachments(attrs, [:image])
    |> cast_assoc(:characters)
    |> validate_required([:name])
    |> unique_constraint(:name)
  end


end

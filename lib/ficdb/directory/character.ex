defmodule Ficdb.Directory.Character do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Ficdb.Directory.{Fanfic, Character, PrimaryRelationship}


  schema "characters" do
    field :description, :string
    field :image, :string
    field :name, :string
    field :fandom_id, :id
    field :submitter_id, :id
    field :updater_id, :id

    has_many :main_character, Fanfic, foreign_key: :main_character_id
    many_to_many :primary_relationship, Fanfic, join_through: PrimaryRelationship, on_replace: :delete


    timestamps()
  end

  def main_character_dropdown_query(query) do
    from g in query,
         join: fanfics in assoc(g, :main_character),
         group_by: g.id,
         having: count(fanfics.id, :distinct) > 0,
         select: {g.name, g.id}
  end

  def relationship_dropdown_query(query) do
    from g in query,
         join: fanfics in assoc(g, :primary_relationship),
         group_by: g.id,
         having: count(fanfics.id, :distinct) > 0,
         select: {g.name, g.id}
  end

  def from_fandom_query(query, fandoms \\ []) do
    from c in query,
      where: c.fandom_id in ^fandoms,
      or_where: is_nil(c.fandom_id)
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:description, :image, :name, :fandom_id])
    |> validate_required([:name])
  end
end
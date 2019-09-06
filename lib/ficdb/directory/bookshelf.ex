defmodule Ficdb.Directory.Bookshelf do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ficdb.Directory.{Fanfic, FanficsBookshelves}


  schema "bookshelves" do
    field :description, :string
    field :name, :string
    field :updater_id, :id
    field :fanfic_count, :integer, virtual: true
    many_to_many :fanfics, Fanfic, join_through: FanficsBookshelves, on_replace: :delete
    has_many :fanfics_bookshelves, FanficsBookshelves, on_replace: :delete
    belongs_to :submitter, Ficdb.Veil.User


    timestamps()
  end

  def user_bookshelves_query(query, user_id) do
    if user_id do
      from b in query,
           where: b.submitter_id == ^user_id,
           left_join: fanfics in assoc(b, :fanfics), as: :fanfics,
           group_by: b.id,
           select: %{
             b |
             fanfic_count: fragment("count(?) as fanfic_count", fanfics.id),
           }
    else
      query
    end
  end

  def base_bookshelves do
    ["want_to_read", "reading", "read", "waiting_for_updates", "dropped", "not_interested"]
  end


  @doc false
  def changeset(bookshelf, attrs) do

    bookshelf
    |> cast(attrs, [:name, :description, :submitter_id, :updater_id])
    |> validate_required([:name])
    |> unique_constraint(:no_duplicate_name, name: :no_duplicate_name)

  end
end

defmodule Ficdb.Directory.Review do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  use Filterable.Phoenix.Model


  schema "reviews" do
    field :content, :string
    field :headline, :string
    field :rating, :integer
    field :updater_id, :id
    field :vote_count, :integer, virtual: true
    field :items_length, :integer, virtual: true

    belongs_to :fanfic, Ficdb.Directory.Fanfic
    belongs_to :submitter, Ficdb.Veil.User
    has_many :votes, Ficdb.Directory.ReviewVote
    has_one :current_user_vote, Ficdb.Directory.ReviewVote

    timestamps()
  end

  def summary_query(query) do
    from r in query,
         left_join: votes in assoc(r, :votes), as: :votes,
         group_by: r.id,
         preload: [
           :submitter,
           votes: :submitter
         ],
         select: %{
           r |
           vote_count: fragment("count(?) as vote_count", votes.id),
           items_length: r.id |> count() |> over()
         }
  end

  def with_fanfic_query(query) do
    from r in query,
      preload: [:fanfic]
  end


  filterable do
    field :submitter_id, cast: :integer, top_param: :search

    paginateable per_page: 15

    @options top_param: :search, default: :inserted_at, cast: :atom
    filter sort(query, field, _conn) do
      cond do
        field == :rating_low ->
          query
          |> order_by([{:asc, :rating}])
        field == :rating_high ->
          query
          |> order_by([{:desc, :rating}])
        field == :most_helpful ->
          query
          |> order_by([{:desc, fragment("vote_count")}])
        field ->
          query
          |> order_by([{:desc, ^field}])
      end
    end

    @options top_param: :search
    filter title(query, value, _conn) do
      from f in query,
           left_join: submitter in assoc(f, :submitter), as: :submitter,
         where: ilike(submitter.username, ^"%#{value}%")
    end


    @options top_param: :search
    filter fandoms(query, filters, _conn) do


      filters = filters
                |> Enum.map(&String.to_integer/1)

      query = from r in query,
                   left_join: fanfics in assoc(r, :fanfic), as: :fanfics

      from [r, votes, fanfics] in query,
           left_join: fandoms in assoc(fanfics, :fandoms),
           where: fandoms.id in ^filters

    end

    @options top_param: :search
    filter genres(query, filters, _conn) do
      filters = filters
                |> Enum.map(&String.to_integer/1)

      from [r, votes, fanfics] in query,
           left_join: genres in assoc(fanfics, :genres),
           where: genres.id in ^filters

    end

  end


  def with_headline(query) do
    from r in query,
         where: not is_nil(r.headline)
  end


  def review_exists_query(query, fanfic_id, current_user_id) do
    from r in Ficdb.Directory.Review,
         where: r.fanfic_id == ^fanfic_id,
         where: r.submitter_id == ^current_user_id
  end

  def from_submitter_query(query, current_user_id) do
    from r in query,
         left_join: votes in assoc(r, :votes), as: :votes,
         where: r.submitter_id == ^current_user_id,
         select: %{vote_count: count(votes.id)}


  end

  def sort_by_options,
      do: [
        "New": :inserted_at,
        "Most Helpful": :most_helpful,
        "5 Star Reviews": :rating_high,
        "1 Star Reviews": :rating_low,
      ]

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:content, :headline, :rating, :fanfic_id, :submitter_id, :updater_id])
    |> validate_required([:rating, :fanfic_id])
    |> unique_constraint(:unique_review_club_constraint, name: :unique_review_club)
  end
end

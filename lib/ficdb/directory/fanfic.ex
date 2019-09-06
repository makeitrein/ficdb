defmodule Ficdb.Directory.Fanfic do
  import Ecto.Changeset
  import Ecto.Query

  use Filterable.Phoenix.Model
  use Ecto.Schema

  alias Ficdb.Repo
  alias Ficdb.Directory.{FanficsGenres, FanficsFandoms, Suggestion, Author, Genre, Review, Fandom, Bookshelf, Character,
                         FanficsBookshelves, PrimaryRelationship}

  schema "fanfics" do
    field :description, :string
    field :first_chapter_at, :utc_datetime
    field :author_name, :string
    field :chapter_count, :integer
    field :is_completed, :boolean, default: false
    field :is_one_shot, :boolean, default: false
    field :last_chapter_at, :utc_datetime
    field :name, :string
    field :status, Ficdb.FanficStatusEnum
    field :url, :string
    field :word_count, :integer
    field :maturity, Ficdb.MaturityEnum

    field :sb_id, :integer
    field :ao3_id, :integer
    field :ff_id, :integer
    field :fp_id, :integer
    field :sv_id, :integer
    field :ah_id, :integer
    field :qq_id, :integer
    field :tb_id, :integer

    field :review_avg, :integer, virtual: true, default: 0
    field :review_count, :integer, virtual: true, default: 0
    field :items_length, :integer, virtual: true, default: 0
    field :weighted_avg, :decimal, virtual: true, default: 0

    many_to_many :genres, Genre, join_through: FanficsGenres, on_replace: :delete
    many_to_many :fandoms, Fandom, join_through: FanficsFandoms, on_replace: :delete
    many_to_many :bookshelves, Bookshelf, join_through: FanficsBookshelves, on_replace: :delete
    has_many :fanfics_bookshelves, FanficsBookshelves

    has_many :reviews, Review
    has_many :suggestions, Suggestion
    has_one :current_user_review, Review
    has_one :current_user_bookshelf, FanficsBookshelves
    has_one :current_user_bookshelf_names, FanficsBookshelves

    belongs_to :main_character, Character
    many_to_many :primary_relationship, Character, join_through: PrimaryRelationship, on_replace: :delete

    belongs_to :author, Author
    belongs_to :submitter, Ficdb.Veil.User
    belongs_to :updater, Ficdb.Veil.User
    belongs_to :approver, Ficdb.Veil.User
    belongs_to :rejector, Ficdb.Veil.User

    timestamps()
  end


  def summary_query(query, current_user_id) do
    current_user_id = current_user_id || 0

    current_user_bookshelf = from b in FanficsBookshelves,
                                  where: b.submitter_id == ^current_user_id,
                                  preload: :bookshelf

    current_user_bookshelf_names = from b in FanficsBookshelves,
                                        where: b.submitter_id == ^current_user_id,
                                        left_join: bookshelf in assoc(b, :bookshelf),
                                        select: bookshelf.name

    current_user_review = from b in Review,
                               where: b.submitter_id == ^current_user_id

    genres = from g in Genre,
                  order_by: :name

    query = from f in query,
                 left_join: reviews in assoc(f, :reviews),
                 as: :reviews,
                 group_by: f.id,
                 preload: [
                   :submitter,
                   :updater,
                   :approver,
                   :author,
                   :main_character,
                   :primary_relationship,
                   :fandoms,
                   genres: ^genres,
                   current_user_bookshelf: ^current_user_bookshelf,
                   current_user_bookshelf_names: ^current_user_bookshelf_names,
                   current_user_review: ^current_user_review,
                   suggestions: ^(
                     Suggestion
                     |> Suggestion.summary_query
                     |> Ficdb.SchemaHelpers.order_by_query({:desc, :updated_at})),
                   reviews: ^(
                     Review
                     |> Review.summary_query
                     |> Ficdb.SchemaHelpers.order_by_query({:desc, :updated_at}))
                 ],
                 select: %{
                   f |
                   review_count: fragment("count(?) as review_count", reviews.id),
                   review_avg: fragment("round(coalesce(?::numeric, 0), 2) as review_avg", avg(reviews.rating)),
                   items_length: f.id
                                 |> count()
                                 |> over(),
                   weighted_avg: fragment(
                     "(count(?) * ? + ? * ?) / (count(?) + ?) as weighted_avg",
                     reviews.id,
                     avg(reviews.rating),
                     20,
                     3.9,
                     reviews.id,
                     20
                   ),
                 }

    # weighted_avg = (v * R + m * C) / (v + m)
    # v = vote count = fragment("review_count")
    # R = average for the fanfic = fragment("review_avg")
    # m = minimum votes = 6
    # C = mean vote across the site = 4.3

  end

  filterable do

    paginateable per_page: 15

    field :submitter_id, cast: :integer

    @options top_param: :search
    filter title(query, value, _conn) do
      from f in query,
           where: ilike(f.name, ^"%#{value}%") or ilike(f.author_name, ^"%#{value}%")
    end

    @options top_param: :search, default: 1
    filter approval_status(query, value, _conn) do
      case value do
        "rejected" ->
          query
          |> where([f], not is_nil(f.rejector_id))
        "unapproved" ->
          query
          |> where([f], is_nil(f.rejector_id))
          |> where([f], is_nil(f.approver_id))
        _ ->
          query
          |> where([f], is_nil(f.rejector_id))
          |> where([f], not is_nil(f.approver_id))
      end
    end

    @options top_param: :search, cast: :integer
    filter submitter_id(query, value, _conn) do
      from f in query,
           where: f.submitter_id == ^value
    end

    @options top_param: :search
    filter fandoms(query, filters, _conn) do

      filters = filters
                |> Enum.map(&String.to_integer/1)

      from f in query,
           left_join: fandoms in assoc(f, :fandoms),
           where: fandoms.id in ^filters,
           having: count(fandoms.id, :distinct) == ^length(filters)

    end

    @options top_param: :search
    filter anti_fandoms(query, filters, _conn) do

      filters = filters
                |> Enum.map(&String.to_integer/1)

      from f in query,
           left_join: fandoms in assoc(f, :fandoms),
           having: not fragment("? && array_agg(?)", ^filters, fandoms.id)

    end

    @options top_param: :search
    filter genres(query, filters, _conn) do
      #  TODO: is this more performant
      #  from p in query, join: t in assoc(p, :tags), group_by: p.id, having: fragment("? <@ array_agg(?)", ^tags_ids, t.id)

      filters = filters
                |> Enum.map(&String.to_integer/1)

      from f in query,
           left_join: genres in assoc(f, :genres),
           where: genres.id in ^filters,
           having: count(genres.id, :distinct) == ^length(filters)

    end

    @options top_param: :search
    filter anti_genres(query, filters, _conn) do
      filters = filters
                |> Enum.map(&String.to_integer/1)

      from f in query,
           left_join: genres in assoc(f, :genres),
           having: not fragment("? && array_agg(?)", ^filters, genres.id)
    end

    @options top_param: :search
    filter bookshelves(query, filters, _conn) do

      filters = filters
                |> Enum.map(&String.to_integer/1)

      from f in query,
           left_join: bookshelves in assoc(f, :bookshelves),
           where: bookshelves.id in ^filters
    end

    @options top_param: :search
    filter anti_bookshelves(query, filters, _conn) do
      filters = filters
                |> Enum.map(&String.to_integer/1)

      from f in query,
           left_join: bookshelves in assoc(f, :bookshelves),
           having: not fragment("? && array_agg(?)", ^filters, bookshelves.id)
    end

    @options top_param: :search
    filter primary_relationship(query, filters, _conn) do
      filters = filters
                |> Enum.map(&String.to_integer/1)

      from f in query,
           left_join: primary_relationship in assoc(f, :primary_relationship),
           where: primary_relationship.id in ^filters,
           having: count(primary_relationship.id, :distinct) == ^length(filters)
    end

    @options top_param: :search
    filter anti_primary_relationship(query, filters, _conn) do
      filters = filters
                |> Enum.map(&String.to_integer/1)

      from f in query,
           left_join: primary_relationship in assoc(f, :primary_relationship),
           having: not fragment("? && array_agg(?)", ^filters, primary_relationship.id)
    end

    @options top_param: :search
    filter anti_bookshelves(query, filters, _conn) do
      filters = filters
                |> Enum.map(&String.to_integer/1)

      from f in query,
           left_join: bookshelves in assoc(f, :bookshelves),
           having: not fragment("? && array_agg(?)", ^filters, bookshelves.id)
    end

    @options top_param: :search, cast: :integer
    filter bookshelf(query, filter, _conn) do
      from f in query,
           left_join: bookshelves in assoc(f, :bookshelves),
           where: bookshelves.id == ^filter

    end

    @options top_param: :search, cast: :integer
    filter review_avg(query, value, _conn) do
      from [f, all_reviews] in query,
           having: avg(all_reviews.rating) > ^value
    end

    @options top_param: :search
    filter word_count(query, filters, _conn) do
      dynamic = Enum.reduce(
        filters,
        false,
        fn filter, query ->
          options = Ficdb.Directory.Fanfic.word_count_options[String.to_existing_atom filter]
          dynamic([f], f.word_count > ^options[:gt] and f.word_count < ^options[:lt] or ^query)
        end
      )

      from f in query, where: ^dynamic

    end

    @options top_param: :search, cast: :integer
    filter maturity(query, filters, _conn) do
      from f in query,
           where: f.maturity in ^filters
    end

    @options top_param: :search, cast: :integer
    filter status(query, filters, _conn) do
      from f in query,
           where: f.status in ^filters
    end

    @options top_param: :search, cast: :integer
    filter main_character_id(query, filters, _conn) do
      from f in query,
           where: f.main_character_id in ^filters
    end

    @options top_param: :search, cast: :integer
    filter anti_main_character_id(query, filters, _conn) do

      from f in query,
           where: not fragment("coalesce(?, ?)", f.main_character_id, 0) in ^filters
    end

    @options top_param: :search, cast: :integer
    filter anti_status(query, filters, _conn) do

      from f in query,
           where: not fragment("coalesce(?, ?)", f.status, 0) in ^filters
    end

    @options top_param: :search, cast: :integer
    filter anti_maturity(query, filters, _conn) do

      from f in query,
           where: not fragment("coalesce(?, ?)", f.maturity, 0) in ^filters
    end

    @options top_param: :search, cast: :boolean
    filter hide_crossovers(query, filter, _conn) do
      case filter do
        false -> query
        true -> from f in query,
                     left_join: fandoms in assoc(f, :fandoms),
                     having: count(fandoms.id, :distinct) == 1
      end
    end

    @options top_param: :search, cast: :boolean
    filter show_crossovers(query, filter, _conn) do
      case filter do
        false -> query
        true -> from f in query,
                     left_join: fandoms in assoc(f, :fandoms),
                     having: count(fandoms.id, :distinct) > 1
      end
    end

    @options top_param: :search, default: :last_reviewed, cast: :atom
    filter sort(
             query,
             field,
             [
               share: [
                 current_user_id: _current_user_id,
                 params: params
               ]
             ]
           ) do

      if !has_named_binding?(query, :reviews) do
        query
      else
        is_page_bookshelf = params["search"]["page"] == "page_bookshelf"
        cond do
          field == :review_count ->
            query
            |> order_by([{:desc, fragment("review_count")}])

          field == :review_count_low ->
            query
            |> order_by([{:asc, fragment("review_count")}])

          field == :last_reviewed ->
            from [f, reviews] in query,
                 order_by: fragment("? DESC NULLS LAST", max(reviews.inserted_at))
          field == :review_avg ->
            from [f, reviews] in query,
                 order_by: fragment("weighted_avg DESC NULLS LAST")
          # weighted_avg = (v * R + m * C) / (v + m)


          # v = vote count = fragment("review_count")

          # R = average for the fanfic = fragment("review_avg")
          # m = minimum votes = 6
          # C = mean vote across the site = 4.3

          is_page_bookshelf ->
            query
            |> group_by([bookshelves: bookshelves], bookshelves.name)
            |> order_by([bookshelves: bookshelves], bookshelves.name)
          field == :name ->
            query
            |> order_by([{:asc, :name}])
          field ->
            query
            |> order_by([{:desc, ^field}])
        end
      end
    end


  end


  def form_query(changeset) do
    changeset
    |> Repo.preload([:genres, :fandoms, :primary_relationship, :main_character])
  end


  def word_count_options do
    [
      "0 - 5k": [
        gt: 0,
        lt: 5000
      ],
      "5k - 30k": [
        gt: 5000,
        lt: 30000
      ],
      "30k - 100k": [
        gt: 30000,
        lt: 100000
      ],
      "100k - 200k": [
        gt: 100000,
        lt: 200000
      ],
      "200k+": [
        gt: 200000,
        lt: 1000000000
      ]
    ]
  end

  def review_avg_options do
    [
      "1+ Star": 1,
      "2+ Star": 2,
      "3+ Star": 3,
      "4+ Star": 4
    ]
  end

  def last_chapter_at_options do
    [
      "Today": %{},
      "Last Week": %{},
      "Last Month": %{},
      "Last 3 Months": %{},
      "Last Year": %{},
    ]
  end

  def sort_by_options,
      do: [
        "Last Reviewed": :last_reviewed,
        "Updated": :last_chapter_at,
        "New": :inserted_at,
        "Top Rated": :review_avg,
        "Most Reviews": :review_count,
        "☞ Need Reviews ☜": :review_count_low,
      ]


  def page_options,
      do: [
        "All Fan Works": :page_all,
        "Reviewed By You": :page_reviewed,
        "Ignored By You": :page_ignored,
      ]


  def page_description,
      do: [
        "All Fan Works": "Organic & Unfiltered",
        "Reviewed By You": "100% Grade-A Opinions",
        "Ignored By You": "Unreviewed Potential"
      ]

  def sort_by_icons,
      do: [
        last_chapter_at: "star",
        first_chapter_at: "calendar",
        inserted_at: "bolt",
        review_avg: "heart",
        review_count: "comments",
        chapter_count: "copy",
        word_count: "album",
        name: "quote-right",
      ]

  def order_by_options,
      do: [
        "Ascending": :asc,
        "Descending": :desc,
      ]


  def approval_status_options,
      do: [
        "Approved": :approved,
        "Unapproved": :unapproved,
      ]

  def power_user_approval_status_options,
      do: approval_status_options ++ ["Rejected": :rejected]


  ## TODO clean this up
  def get_genres (ids) do
    (ids || [])
    |> Enum.map(&Ficdb.Directory.get_genre!/1)
  end

  def get_fandoms (ids) do
    (ids || [])
    |> Enum.map(&Ficdb.Directory.get_fandom!/1)
  end

  def get_characters (ids) do
    (ids || [])
    |> Enum.map(&Ficdb.Directory.get_character!/1)
  end

  @doc false
  def changeset(fanfic, attrs) do
    fanfic
    |> cast(
         attrs,
         [
           :name,
           :description,
           :word_count,
           :status,
           :maturity,
           :first_chapter_at,
           :last_chapter_at,
           :chapter_count,
           :author_name,
           :url,
           :main_character_id,
           :author_id,
           :submitter_id,
           :updater_id,
           :sb_id,
           :sv_id,
           :ao3_id,
           :fp_id,
           :ff_id,
           :ah_id,
           :qq_id,
           :tb_id,
         ]
       )
    |> validate_required(
         [
           :name,
           :maturity,
           :status,
           :main_character_id,
           :description,
           :word_count,
           :author_name,
         ]
       )
    |> put_assoc(:genres, get_genres(attrs["genres"]))
    |> put_assoc(:fandoms, get_fandoms(attrs["fandoms"]))
    |> put_assoc(:primary_relationship, get_characters(attrs["primary_relationship"]))
    |> validate_length(:genres, min: 1)
    |> validate_length(:fandoms, min: 1)
    |> unique_constraint(:sv_id)
    |> unique_constraint(:ao3_i)
    |> unique_constraint(:fp_id)
    |> unique_constraint(:ff_id)
    |> unique_constraint(:url)
  end

  def cron_changeset(fanfic, attrs) do
    fanfic
    |> cast(
         attrs,
         [
           :word_count,
           :status,
           :last_chapter_at,
           :chapter_count,
         ]
       )
    |> validate_required(
         [
           :word_count,
           :last_chapter_at,
           :chapter_count,
         ]
       )
  end

  def approve_changeset(fanfic, attrs) do
    fanfic
    |> cast(
         attrs,
         [
           :approver_id,
           :rejector_id
         ]
       )
  end
end


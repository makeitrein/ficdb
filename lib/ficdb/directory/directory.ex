defmodule Ficdb.Directory do
  @moduledoc """
  The Fanfics context.
  """

  import Ecto.Query, warn: false
  alias Ficdb.Repo

  alias Ficdb.Directory.Fandom

  def list_all query do
    Repo.all(query)
  end

  def get_one query do
    Repo.one(query)
  end

  @doc """
  Returns the list of fandoms.

  ## Examples

      iex> list_fandoms()
      [%Fandom{}, ...]

  """
  def list_fandoms do
    Repo.all(Fandom)
  end


  @doc """
  Gets a single fandom.

  Raises `Ecto.NoResultsError` if the Fandom does not exist.

  ## Examples

      iex> get_fandom!(123)
      %Fandom{}

      iex> get_fandom!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fandom!(id),
      do: Repo.get!(Fandom, id)
          |> Repo.preload(:characters)

  @doc """
  Creates a fandom.

  ## Examples

      iex> create_fandom(%{field: value})
      {:ok, %Fandom{}}

      iex> create_fandom(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fandom(attrs \\ %{}) do
    %Fandom{}
    |> Fandom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fandom.

  ## Examples

      iex> update_fandom(fandom, %{field: new_value})
      {:ok, %Fandom{}}

      iex> update_fandom(fandom, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fandom(%Fandom{} = fandom, attrs) do
    fandom
    |> Fandom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Fandom.

  ## Examples

      iex> delete_fandom(fandom)
      {:ok, %Fandom{}}

      iex> delete_fandom(fandom)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fandom(%Fandom{} = fandom) do
    Repo.delete(fandom)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fandom changes.

  ## Examples

      iex> change_fandom(fandom)
      %Ecto.Changeset{source: %Fandom{}}

  """
  def change_fandom(%Fandom{} = fandom) do
    Fandom.changeset(fandom, %{})
  end

  alias Ficdb.Directory.Genre

  @doc """
  Returns the list of genres.

  ## Examples

      iex> list_genres()
      [%Genre{}, ...]

  """
  def list_genres do
    Repo.all(Genre)
  end

  @doc """
  Gets a single genre.

  Raises `Ecto.NoResultsError` if the Genre does not exist.

  ## Examples

      iex> get_genre!(123)
      %Genre{}

      iex> get_genre!(456)
      ** (Ecto.NoResultsError)

  """
  def get_genre!(id), do: Repo.get!(Genre, id)

  @doc """
  Creates a genre.

  ## Examples

      iex> create_genre(%{field: value})
      {:ok, %Genre{}}

      iex> create_genre(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_genre(attrs \\ %{}) do
    %Genre{}
    |> Genre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a genre.

  ## Examples

      iex> update_genre(genre, %{field: new_value})
      {:ok, %Genre{}}

      iex> update_genre(genre, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_genre(%Genre{} = genre, attrs) do
    genre
    |> Genre.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Genre.

  ## Examples

      iex> delete_genre(genre)
      {:ok, %Genre{}}

      iex> delete_genre(genre)
      {:error, %Ecto.Changeset{}}

  """
  def delete_genre(%Genre{} = genre) do
    Repo.delete(genre)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking genre changes.

  ## Examples

      iex> change_genre(genre)
      %Ecto.Changeset{source: %Genre{}}

  """
  def change_genre(%Genre{} = genre) do
    Genre.changeset(genre, %{})
  end

  alias Ficdb.Directory.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{source: %Tag{}}

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end

  alias Ficdb.Directory.Character

  @doc """
  Returns the list of characters.

  ## Examples

      iex> list_characters()
      [%Character{}, ...]

  """
  def list_characters do
    Repo.all(Character)
  end

  @doc """
  Gets a single character.

  Raises `Ecto.NoResultsError` if the Character does not exist.

  ## Examples

      iex> get_character!(123)
      %Character{}

      iex> get_character!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character!(id), do: Repo.get!(Character, id)

  @doc """
  Creates a character.

  ## Examples

      iex> create_character(%{field: value})
      {:ok, %Character{}}

      iex> create_character(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character(attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  def create_all_characters(attrs_map \\ [%{}], fandom_id) do
    entries = attrs_map
    |> Enum.map(
         fn ({_key, name}) -> (%{name: name, fandom_id: fandom_id, inserted_at: NaiveDateTime.utc_now |> NaiveDateTime.truncate(:second), updated_at: NaiveDateTime.utc_now |> NaiveDateTime.truncate(:second)}) end
       )

    Repo.insert_all(Character, entries)
  end

  @doc """
  Updates a character.

  ## Examples

      iex> update_character(character, %{field: new_value})
      {:ok, %Character{}}

      iex> update_character(character, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Character.

  ## Examples

      iex> delete_character(character)
      {:ok, %Character{}}

      iex> delete_character(character)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character changes.

  ## Examples

      iex> change_character(character)
      %Ecto.Changeset{source: %Character{}}

  """
  def change_character(%Character{} = character) do
    Character.changeset(character, %{})
  end

  alias Ficdb.Directory.Fanfic

  @doc """
  Returns the list of fanfics.

  ## Examples

      iex> list_fanfics()
      [%Fanfic{}, ...]

  """

  def list_fanfics(current_user_id) do
    Fanfic
    |> Fanfic.summary_query(current_user_id)
    |> Repo.all
  end

  @doc """
  Gets a single fanfic.

  Raises `Ecto.NoResultsError` if the Fanfic does not exist.

  ## Examples

      iex> get_fanfic!(123)
      %Fanfic{}

      iex> get_fanfic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fanfic!(id, current_user_id),
      do: Fanfic
          |> Fanfic.summary_query(current_user_id)
          |> Repo.get!(id)

  @doc """
  Creates a fanfic.

  ## Examples

      iex> create_fanfic(%{field: value})
      {:ok, %Fanfic{}}

      iex> create_fanfic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fanfic(attrs \\ %{}) do
    %Fanfic{}
    |> Fanfic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fanfic.

  ## Examples

      iex> update_fanfic(fanfic, %{field: new_value})
      {:ok, %Fanfic{}}

      iex> update_fanfic(fanfic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fanfic(%Fanfic{} = fanfic, attrs) do
    fanfic
    |> Fanfic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Fanfic.

  ## Examples

      iex> delete_fanfic(fanfic)
      {:ok, %Fanfic{}}

      iex> delete_fanfic(fanfic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fanfic(%Fanfic{} = fanfic) do
    Repo.delete(fanfic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fanfic changes.

  ## Examples

      iex> change_fanfic(fanfic)
      %Ecto.Changeset{source: %Fanfic{}}

  """
  def change_fanfic(%Fanfic{} = fanfic) do
    Fanfic.changeset(fanfic, %{})
  end

  alias Ficdb.Directory.Author

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(Author)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{source: %Author{}}

  """
  def change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

  alias Ficdb.Directory.Chapter

  @doc """
  Returns the list of chapters.

  ## Examples

      iex> list_chapters()
      [%Chapter{}, ...]

  """
  def list_chapters do
    Repo.all(Chapter)
  end

  @doc """
  Gets a single chapter.

  Raises `Ecto.NoResultsError` if the Chapter does not exist.

  ## Examples

      iex> get_chapter!(123)
      %Chapter{}

      iex> get_chapter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chapter!(id), do: Repo.get!(Chapter, id)

  @doc """
  Creates a chapter.

  ## Examples

      iex> create_chapter(%{field: value})
      {:ok, %Chapter{}}

      iex> create_chapter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chapter(attrs \\ %{}) do
    %Chapter{}
    |> Chapter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chapter.

  ## Examples

      iex> update_chapter(chapter, %{field: new_value})
      {:ok, %Chapter{}}

      iex> update_chapter(chapter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chapter(%Chapter{} = chapter, attrs) do
    chapter
    |> Chapter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Chapter.

  ## Examples

      iex> delete_chapter(chapter)
      {:ok, %Chapter{}}

      iex> delete_chapter(chapter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chapter(%Chapter{} = chapter) do
    Repo.delete(chapter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chapter changes.

  ## Examples

      iex> change_chapter(chapter)
      %Ecto.Changeset{source: %Chapter{}}

  """
  def change_chapter(%Chapter{} = chapter) do
    Chapter.changeset(chapter, %{})
  end

  alias Ficdb.Directory.Review

  @doc """
  Returns the list of reviews.

  ## Examples

      iex> list_reviews()
      [%Review{}, ...]

  """
  def list_reviews do
    Repo.all(Review)
  end

  @doc """
  Gets a single review.

  Raises `Ecto.NoResultsError` if the Review does not exist.

  ## Examples

      iex> get_review!(123)
      %Review{}

      iex> get_review!(456)
      ** (Ecto.NoResultsError)

  """
  def get_review!(id),
      do: Repo.get!(Review, id)
          |> Repo.preload([:fanfic, :submitter])

  @doc """
  Creates a review.

  ## Examples

      iex> create_review(%{field: value})
      {:ok, %Review{}}

      iex> create_review(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_review(attrs \\ %{}) do
    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a review.

  ## Examples

      iex> update_review(review, %{field: new_value})
      {:ok, %Review{}}

      iex> update_review(review, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Review.

  ## Examples

      iex> delete_review(review)
      {:ok, %Review{}}

      iex> delete_review(review)
      {:error, %Ecto.Changeset{}}

  """
  def delete_review(%Review{} = review) do
    Repo.delete(review)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes.

  ## Examples

      iex> change_review(review)
      %Ecto.Changeset{source: %Review{}}

  """
  def change_review(%Review{} = review) do
    Review.changeset(review, %{})
  end





  alias Ficdb.Directory.Suggestion

  @doc """
  Returns the list of suggestions.

  ## Examples

      iex> list_suggestions()
      [%Suggestion{}, ...]

  """
  def list_suggestions do
    Suggestion |> Suggestion.list_query |> Repo.all
  end

  @doc """
  Gets a single suggestion.

  Raises `Ecto.NoResultsError` if the Suggestion does not exist.

  ## Examples

      iex> get_suggestion!(123)
      %Suggestion{}

      iex> get_suggestion!(456)
      ** (Ecto.NoResultsError)

  """
  def get_suggestion!(id),
      do: Repo.get!(Suggestion, id)
          |> Repo.preload([:fanfic, :submitter])

  @doc """
  Creates a suggestion.

  ## Examples

      iex> create_suggestion(%{field: value})
      {:ok, %Suggestion{}}

      iex> create_suggestion(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_suggestion(attrs \\ %{}) do
    %Suggestion{}
    |> Suggestion.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a suggestion.

  ## Examples

      iex> update_suggestion(suggestion, %{field: new_value})
      {:ok, %Suggestion{}}

      iex> update_suggestion(suggestion, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_suggestion(%Suggestion{} = suggestion, attrs) do
    suggestion
    |> Suggestion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Suggestion.

  ## Examples

      iex> delete_suggestion(suggestion)
      {:ok, %Suggestion{}}

      iex> delete_suggestion(suggestion)
      {:error, %Ecto.Changeset{}}

  """
  def delete_suggestion(%Suggestion{} = suggestion) do
    Repo.delete(suggestion)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking suggestion changes.

  ## Examples

      iex> change_suggestion(suggestion)
      %Ecto.Changeset{source: %Suggestion{}}

  """
  def change_suggestion(%Suggestion{} = suggestion) do
    Suggestion.changeset(suggestion, %{})
  end
  
  
  
  
  
  

  alias Ficdb.Directory.Bookshelf
  alias Ficdb.Directory.FanficsBookshelves

  @doc """
  Returns the list of bookshelves.

  ## Examples

      iex> list_bookshelves()
      [%Bookshelf{}, ...]

  """
  def list_bookshelves do
    Repo.all(Bookshelf)
  end

  @doc """
  Gets a single bookshelf.

  Raises `Ecto.NoResultsError` if the Bookshelf does not exist.

  ## Examples

      iex> get_bookshelf!(123)
      %Bookshelf{}

      iex> get_bookshelf!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bookshelf!(id), do: Repo.get!(Bookshelf, id)

  @doc """
  Creates a bookshelf.

  ## Examples

      iex> create_bookshelf(%{field: value})
      {:ok, %Bookshelf{}}

      iex> create_bookshelf(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bookshelf(attrs \\ %{}) do
    %Bookshelf{}
    |> Bookshelf.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bookshelf.

  ## Examples

      iex> update_bookshelf(bookshelf, %{field: new_value})
      {:ok, %Bookshelf{}}

      iex> update_bookshelf(bookshelf, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bookshelf(%Bookshelf{} = bookshelf, attrs) do
    bookshelf
    |> Bookshelf.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Bookshelf.

  ## Examples

      iex> delete_bookshelf(bookshelf)
      {:ok, %Bookshelf{}}

      iex> delete_bookshelf(bookshelf)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bookshelf(%Bookshelf{} = bookshelf) do
    Repo.delete(bookshelf)
  end

  def delete_fanfics_bookshelves(clauses) do
    FanficsBookshelves
    |> Repo.get_by(clauses)
    |> Repo.delete
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bookshelf changes.

  ## Examples

      iex> change_bookshelf(bookshelf)
      %Ecto.Changeset{source: %Bookshelf{}}

  """
  def change_bookshelf(%Bookshelf{} = bookshelf) do
    Bookshelf.changeset(bookshelf, %{})
  end

  def get_by_bookshelf(clauses) do
    Bookshelf
    |> preload([:fanfics, :fanfics_bookshelves])
    |> Repo.get_by(clauses)
  end

  def get_by_fanfics_bookshelves(clauses) do
    FanficsBookshelves
    |> Repo.get_by(clauses)
  end

  def create_fanfics_bookshelves(attrs \\ %{}) do
    %FanficsBookshelves{}
    |> FanficsBookshelves.changeset(attrs)
    |> Repo.insert()
  end

  def update_fanfics_bookshelves(%FanficsBookshelves{} = fanfics_bookshelves, attrs) do
    fanfics_bookshelves
    |> FanficsBookshelves.changeset(attrs)
    |> Repo.update()
  end

  def find_or_create_bookshelf(bookshelf_params) do
    case get_by_bookshelf(bookshelf_params)  do
      nil -> create_bookshelf(bookshelf_params)
      bookshelf -> bookshelf
    end

  end

  def update_all_users_bookshelves() do
    users = Repo.all(Ficdb.Veil.User)
            |> Repo.preload([:bookshelves, :requests, :sessions, :submitted_fanfics, :updated_fanfics])
    for user <- users do
      user_changeset = Ecto.Changeset.change user
      user_bookshelves_names = Enum.map(user.bookshelves, &(&1.name))
      bookshelves_to_add = Enum.filter(
        Bookshelf.base_bookshelves,
        fn bookshelf -> bookshelf not in user_bookshelves_names end
      )

      for bookshelf <- bookshelves_to_add do
        create_bookshelf(%{submitter_id: user.id, name: bookshelf})
      end
    end
  end

  alias Ficdb.Directory.ReviewVote

  def create_review_vote(attrs \\ %{}) do
    %ReviewVote{}
    |> ReviewVote.changeset(attrs)
    |> Repo.insert()
  end

  def delete_review_vote(%ReviewVote{} = ReviewVote) do
    Repo.delete(ReviewVote)
  end
end

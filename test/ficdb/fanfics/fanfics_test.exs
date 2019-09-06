defmodule Ficdb.DirectoryTest do
  use Ficdb.DataCase

  alias Ficdb.Directory

  describe "fandoms" do
    alias Ficdb.Directory.Fandom

    @valid_attrs %{description: "some description", name: "some name", thumbnail: "some thumbnail"}
    @update_attrs %{description: "some updated description", name: "some updated name", thumbnail: "some updated thumbnail"}
    @invalid_attrs %{description: nil, name: nil, thumbnail: nil}

    def fandom_fixture(attrs \\ %{}) do
      {:ok, fandom} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_fandom()

      fandom
    end

    test "list_fandoms/0 returns all fandoms" do
      fandom = fandom_fixture()
      assert Fanfics.list_fandoms() == [fandom]
    end

    test "get_fandom!/1 returns the fandom with given id" do
      fandom = fandom_fixture()
      assert Fanfics.get_fandom!(fandom.id) == fandom
    end

    test "create_fandom/1 with valid data creates a fandom" do
      assert {:ok, %Fandom{} = fandom} = Fanfics.create_fandom(@valid_attrs)
      assert fandom.description == "some description"
      assert fandom.name == "some name"
      assert fandom.thumbnail == "some thumbnail"
    end

    test "create_fandom/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_fandom(@invalid_attrs)
    end

    test "update_fandom/2 with valid data updates the fandom" do
      fandom = fandom_fixture()
      assert {:ok, fandom} = Fanfics.update_fandom(fandom, @update_attrs)
      assert %Fandom{} = fandom
      assert fandom.description == "some updated description"
      assert fandom.name == "some updated name"
      assert fandom.thumbnail == "some updated thumbnail"
    end

    test "update_fandom/2 with invalid data returns error changeset" do
      fandom = fandom_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_fandom(fandom, @invalid_attrs)
      assert fandom == Fanfics.get_fandom!(fandom.id)
    end

    test "delete_fandom/1 deletes the fandom" do
      fandom = fandom_fixture()
      assert {:ok, %Fandom{}} = Fanfics.delete_fandom(fandom)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_fandom!(fandom.id) end
    end

    test "change_fandom/1 returns a fandom changeset" do
      fandom = fandom_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_fandom(fandom)
    end
  end

  describe "fandoms" do
    alias Ficdb.Directory.Fandom

    @valid_attrs %{author: "some author", description: "some description", name: "some name", thumbnail: "some thumbnail"}
    @update_attrs %{author: "some updated author", description: "some updated description", name: "some updated name", thumbnail: "some updated thumbnail"}
    @invalid_attrs %{author: nil, description: nil, name: nil, thumbnail: nil}

    def fandom_fixture(attrs \\ %{}) do
      {:ok, fandom} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_fandom()

      fandom
    end

    test "list_fandoms/0 returns all fandoms" do
      fandom = fandom_fixture()
      assert Fanfics.list_fandoms() == [fandom]
    end

    test "get_fandom!/1 returns the fandom with given id" do
      fandom = fandom_fixture()
      assert Fanfics.get_fandom!(fandom.id) == fandom
    end

    test "create_fandom/1 with valid data creates a fandom" do
      assert {:ok, %Fandom{} = fandom} = Fanfics.create_fandom(@valid_attrs)
      assert fandom.author == "some author"
      assert fandom.description == "some description"
      assert fandom.name == "some name"
      assert fandom.thumbnail == "some thumbnail"
    end

    test "create_fandom/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_fandom(@invalid_attrs)
    end

    test "update_fandom/2 with valid data updates the fandom" do
      fandom = fandom_fixture()
      assert {:ok, fandom} = Fanfics.update_fandom(fandom, @update_attrs)
      assert %Fandom{} = fandom
      assert fandom.author == "some updated author"
      assert fandom.description == "some updated description"
      assert fandom.name == "some updated name"
      assert fandom.thumbnail == "some updated thumbnail"
    end

    test "update_fandom/2 with invalid data returns error changeset" do
      fandom = fandom_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_fandom(fandom, @invalid_attrs)
      assert fandom == Fanfics.get_fandom!(fandom.id)
    end

    test "delete_fandom/1 deletes the fandom" do
      fandom = fandom_fixture()
      assert {:ok, %Fandom{}} = Fanfics.delete_fandom(fandom)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_fandom!(fandom.id) end
    end

    test "change_fandom/1 returns a fandom changeset" do
      fandom = fandom_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_fandom(fandom)
    end
  end

  describe "fandoms" do
    alias Ficdb.Directory.Fandom

    @valid_attrs %{author: "some author", description: "some description", name: "some name", thumbnail: "some thumbnail", url: "some url"}
    @update_attrs %{author: "some updated author", description: "some updated description", name: "some updated name", thumbnail: "some updated thumbnail", url: "some updated url"}
    @invalid_attrs %{author: nil, description: nil, name: nil, thumbnail: nil, url: nil}

    def fandom_fixture(attrs \\ %{}) do
      {:ok, fandom} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_fandom()

      fandom
    end

    test "list_fandoms/0 returns all fandoms" do
      fandom = fandom_fixture()
      assert Fanfics.list_fandoms() == [fandom]
    end

    test "get_fandom!/1 returns the fandom with given id" do
      fandom = fandom_fixture()
      assert Fanfics.get_fandom!(fandom.id) == fandom
    end

    test "create_fandom/1 with valid data creates a fandom" do
      assert {:ok, %Fandom{} = fandom} = Fanfics.create_fandom(@valid_attrs)
      assert fandom.author == "some author"
      assert fandom.description == "some description"
      assert fandom.name == "some name"
      assert fandom.thumbnail == "some thumbnail"
      assert fandom.url == "some url"
    end

    test "create_fandom/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_fandom(@invalid_attrs)
    end

    test "update_fandom/2 with valid data updates the fandom" do
      fandom = fandom_fixture()
      assert {:ok, fandom} = Fanfics.update_fandom(fandom, @update_attrs)
      assert %Fandom{} = fandom
      assert fandom.author == "some updated author"
      assert fandom.description == "some updated description"
      assert fandom.name == "some updated name"
      assert fandom.thumbnail == "some updated thumbnail"
      assert fandom.url == "some updated url"
    end

    test "update_fandom/2 with invalid data returns error changeset" do
      fandom = fandom_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_fandom(fandom, @invalid_attrs)
      assert fandom == Fanfics.get_fandom!(fandom.id)
    end

    test "delete_fandom/1 deletes the fandom" do
      fandom = fandom_fixture()
      assert {:ok, %Fandom{}} = Fanfics.delete_fandom(fandom)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_fandom!(fandom.id) end
    end

    test "change_fandom/1 returns a fandom changeset" do
      fandom = fandom_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_fandom(fandom)
    end
  end

  describe "fandoms" do
    alias Ficdb.Directory.Fandom

    @valid_attrs %{author: "some author", description: "some description", image: "some image", name: "some name", url: "some url"}
    @update_attrs %{author: "some updated author", description: "some updated description", image: "some updated image", name: "some updated name", url: "some updated url"}
    @invalid_attrs %{author: nil, description: nil, image: nil, name: nil, url: nil}

    def fandom_fixture(attrs \\ %{}) do
      {:ok, fandom} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_fandom()

      fandom
    end

    test "list_fandoms/0 returns all fandoms" do
      fandom = fandom_fixture()
      assert Fanfics.list_fandoms() == [fandom]
    end

    test "get_fandom!/1 returns the fandom with given id" do
      fandom = fandom_fixture()
      assert Fanfics.get_fandom!(fandom.id) == fandom
    end

    test "create_fandom/1 with valid data creates a fandom" do
      assert {:ok, %Fandom{} = fandom} = Fanfics.create_fandom(@valid_attrs)
      assert fandom.author == "some author"
      assert fandom.description == "some description"
      assert fandom.image == "some image"
      assert fandom.name == "some name"
      assert fandom.url == "some url"
    end

    test "create_fandom/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_fandom(@invalid_attrs)
    end

    test "update_fandom/2 with valid data updates the fandom" do
      fandom = fandom_fixture()
      assert {:ok, fandom} = Fanfics.update_fandom(fandom, @update_attrs)
      assert %Fandom{} = fandom
      assert fandom.author == "some updated author"
      assert fandom.description == "some updated description"
      assert fandom.image == "some updated image"
      assert fandom.name == "some updated name"
      assert fandom.url == "some updated url"
    end

    test "update_fandom/2 with invalid data returns error changeset" do
      fandom = fandom_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_fandom(fandom, @invalid_attrs)
      assert fandom == Fanfics.get_fandom!(fandom.id)
    end

    test "delete_fandom/1 deletes the fandom" do
      fandom = fandom_fixture()
      assert {:ok, %Fandom{}} = Fanfics.delete_fandom(fandom)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_fandom!(fandom.id) end
    end

    test "change_fandom/1 returns a fandom changeset" do
      fandom = fandom_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_fandom(fandom)
    end
  end

  describe "genres" do
    alias Ficdb.Directory.Genre

    @valid_attrs %{description: "some description", image: "some image", name: "some name"}
    @update_attrs %{description: "some updated description", image: "some updated image", name: "some updated name"}
    @invalid_attrs %{description: nil, image: nil, name: nil}

    def genre_fixture(attrs \\ %{}) do
      {:ok, genre} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_genre()

      genre
    end

    test "list_genres/0 returns all genres" do
      genre = genre_fixture()
      assert Fanfics.list_genres() == [genre]
    end

    test "get_genre!/1 returns the genre with given id" do
      genre = genre_fixture()
      assert Fanfics.get_genre!(genre.id) == genre
    end

    test "create_genre/1 with valid data creates a genre" do
      assert {:ok, %Genre{} = genre} = Fanfics.create_genre(@valid_attrs)
      assert genre.description == "some description"
      assert genre.image == "some image"
      assert genre.name == "some name"
    end

    test "create_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_genre(@invalid_attrs)
    end

    test "update_genre/2 with valid data updates the genre" do
      genre = genre_fixture()
      assert {:ok, genre} = Fanfics.update_genre(genre, @update_attrs)
      assert %Genre{} = genre
      assert genre.description == "some updated description"
      assert genre.image == "some updated image"
      assert genre.name == "some updated name"
    end

    test "update_genre/2 with invalid data returns error changeset" do
      genre = genre_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_genre(genre, @invalid_attrs)
      assert genre == Fanfics.get_genre!(genre.id)
    end

    test "delete_genre/1 deletes the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{}} = Fanfics.delete_genre(genre)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_genre!(genre.id) end
    end

    test "change_genre/1 returns a genre changeset" do
      genre = genre_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_genre(genre)
    end
  end

  describe "tags" do
    alias Ficdb.Directory.Tag

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def tag_fixture(attrs \\ %{}) do
      {:ok, tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_tag()

      tag
    end

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Fanfics.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Fanfics.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      assert {:ok, %Tag{} = tag} = Fanfics.create_tag(@valid_attrs)
      assert tag.description == "some description"
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, tag} = Fanfics.update_tag(tag, @update_attrs)
      assert %Tag{} = tag
      assert tag.description == "some updated description"
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_tag(tag, @invalid_attrs)
      assert tag == Fanfics.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Fanfics.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_tag(tag)
    end
  end

  describe "characters" do
    alias Ficdb.Directory.Character

    @valid_attrs %{description: "some description", image: "some image", name: "some name"}
    @update_attrs %{description: "some updated description", image: "some updated image", name: "some updated name"}
    @invalid_attrs %{description: nil, image: nil, name: nil}

    def character_fixture(attrs \\ %{}) do
      {:ok, character} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_character()

      character
    end

    test "list_characters/0 returns all characters" do
      character = character_fixture()
      assert Fanfics.list_characters() == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Fanfics.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      assert {:ok, %Character{} = character} = Fanfics.create_character(@valid_attrs)
      assert character.description == "some description"
      assert character.image == "some image"
      assert character.name == "some name"
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      assert {:ok, character} = Fanfics.update_character(character, @update_attrs)
      assert %Character{} = character
      assert character.description == "some updated description"
      assert character.image == "some updated image"
      assert character.name == "some updated name"
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_character(character, @invalid_attrs)
      assert character == Fanfics.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Fanfics.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_character(character)
    end
  end

  describe "fanfics" do
    alias Ficdb.Directory.Fanfic

    @valid_attrs %{description: "some description", first_chapter_at: "2010-04-17 14:00:00.000000Z", is_completed: true, is_one_shot: true, last_chapter_at: "2010-04-17 14:00:00.000000Z", name: "some name", status: "some status", urls: [], word_count: 42}
    @update_attrs %{description: "some updated description", first_chapter_at: "2011-05-18 15:01:01.000000Z", is_completed: false, is_one_shot: false, last_chapter_at: "2011-05-18 15:01:01.000000Z", name: "some updated name", status: "some updated status", urls: [], word_count: 43}
    @invalid_attrs %{description: nil, first_chapter_at: nil, is_completed: nil, is_one_shot: nil, last_chapter_at: nil, name: nil, status: nil, urls: nil, word_count: nil}

    def fanfic_fixture(attrs \\ %{}) do
      {:ok, fanfic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_fanfic()

      fanfic
    end

    test "list_fanfics/0 returns all fanfics" do
      fanfic = fanfic_fixture()
      assert Fanfics.list_fanfics() == [fanfic]
    end

    test "get_fanfic!/1 returns the fanfic with given id" do
      fanfic = fanfic_fixture()
      assert Fanfics.get_fanfic!(fanfic.id) == fanfic
    end

    test "create_fanfic/1 with valid data creates a fanfic" do
      assert {:ok, %Fanfic{} = fanfic} = Fanfics.create_fanfic(@valid_attrs)
      assert fanfic.description == "some description"
      assert fanfic.first_chapter_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert fanfic.is_completed == true
      assert fanfic.is_one_shot == true
      assert fanfic.last_chapter_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert fanfic.name == "some name"
      assert fanfic.status == "some status"
      assert fanfic.urls == []
      assert fanfic.word_count == 42
    end

    test "create_fanfic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_fanfic(@invalid_attrs)
    end

    test "update_fanfic/2 with valid data updates the fanfic" do
      fanfic = fanfic_fixture()
      assert {:ok, fanfic} = Fanfics.update_fanfic(fanfic, @update_attrs)
      assert %Fanfic{} = fanfic
      assert fanfic.description == "some updated description"
      assert fanfic.first_chapter_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert fanfic.is_completed == false
      assert fanfic.is_one_shot == false
      assert fanfic.last_chapter_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert fanfic.name == "some updated name"
      assert fanfic.status == "some updated status"
      assert fanfic.urls == []
      assert fanfic.word_count == 43
    end

    test "update_fanfic/2 with invalid data returns error changeset" do
      fanfic = fanfic_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_fanfic(fanfic, @invalid_attrs)
      assert fanfic == Fanfics.get_fanfic!(fanfic.id)
    end

    test "delete_fanfic/1 deletes the fanfic" do
      fanfic = fanfic_fixture()
      assert {:ok, %Fanfic{}} = Fanfics.delete_fanfic(fanfic)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_fanfic!(fanfic.id) end
    end

    test "change_fanfic/1 returns a fanfic changeset" do
      fanfic = fanfic_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_fanfic(fanfic)
    end
  end

  describe "authors" do
    alias Ficdb.Directory.Author

    @valid_attrs %{name: "some name", urls: []}
    @update_attrs %{name: "some updated name", urls: []}
    @invalid_attrs %{name: nil, urls: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Fanfics.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Fanfics.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = Fanfics.create_author(@valid_attrs)
      assert author.name == "some name"
      assert author.urls == []
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, author} = Fanfics.update_author(author, @update_attrs)
      assert %Author{} = author
      assert author.name == "some updated name"
      assert author.urls == []
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_author(author, @invalid_attrs)
      assert author == Fanfics.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Fanfics.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_author(author)
    end
  end

  describe "chapters" do
    alias Ficdb.Directory.Chapter

    @valid_attrs %{posted_at: "2010-04-17 14:00:00.000000Z", reactions: 42, url: "some url"}
    @update_attrs %{posted_at: "2011-05-18 15:01:01.000000Z", reactions: 43, url: "some updated url"}
    @invalid_attrs %{posted_at: nil, reactions: nil, url: nil}

    def chapter_fixture(attrs \\ %{}) do
      {:ok, chapter} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_chapter()

      chapter
    end

    test "list_chapters/0 returns all chapters" do
      chapter = chapter_fixture()
      assert Fanfics.list_chapters() == [chapter]
    end

    test "get_chapter!/1 returns the chapter with given id" do
      chapter = chapter_fixture()
      assert Fanfics.get_chapter!(chapter.id) == chapter
    end

    test "create_chapter/1 with valid data creates a chapter" do
      assert {:ok, %Chapter{} = chapter} = Fanfics.create_chapter(@valid_attrs)
      assert chapter.posted_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert chapter.reactions == 42
      assert chapter.url == "some url"
    end

    test "create_chapter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_chapter(@invalid_attrs)
    end

    test "update_chapter/2 with valid data updates the chapter" do
      chapter = chapter_fixture()
      assert {:ok, chapter} = Fanfics.update_chapter(chapter, @update_attrs)
      assert %Chapter{} = chapter
      assert chapter.posted_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert chapter.reactions == 43
      assert chapter.url == "some updated url"
    end

    test "update_chapter/2 with invalid data returns error changeset" do
      chapter = chapter_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_chapter(chapter, @invalid_attrs)
      assert chapter == Fanfics.get_chapter!(chapter.id)
    end

    test "delete_chapter/1 deletes the chapter" do
      chapter = chapter_fixture()
      assert {:ok, %Chapter{}} = Fanfics.delete_chapter(chapter)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_chapter!(chapter.id) end
    end

    test "change_chapter/1 returns a chapter changeset" do
      chapter = chapter_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_chapter(chapter)
    end
  end

  describe "reviews" do
    alias Ficdb.Directory.Review

    @valid_attrs %{content: "some content", rating: 42}
    @update_attrs %{content: "some updated content", rating: 43}
    @invalid_attrs %{content: nil, rating: nil}

    def review_fixture(attrs \\ %{}) do
      {:ok, review} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_review()

      review
    end

    test "list_reviews/0 returns all reviews" do
      review = review_fixture()
      assert Fanfics.list_reviews() == [review]
    end

    test "get_review!/1 returns the review with given id" do
      review = review_fixture()
      assert Fanfics.get_review!(review.id) == review
    end

    test "create_review/1 with valid data creates a review" do
      assert {:ok, %Review{} = review} = Fanfics.create_review(@valid_attrs)
      assert review.content == "some content"
      assert review.rating == 42
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_review(@invalid_attrs)
    end

    test "update_review/2 with valid data updates the review" do
      review = review_fixture()
      assert {:ok, review} = Fanfics.update_review(review, @update_attrs)
      assert %Review{} = review
      assert review.content == "some updated content"
      assert review.rating == 43
    end

    test "update_review/2 with invalid data returns error changeset" do
      review = review_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_review(review, @invalid_attrs)
      assert review == Fanfics.get_review!(review.id)
    end

    test "delete_review/1 deletes the review" do
      review = review_fixture()
      assert {:ok, %Review{}} = Fanfics.delete_review(review)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_review!(review.id) end
    end

    test "change_review/1 returns a review changeset" do
      review = review_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_review(review)
    end
  end

  describe "bookshelves" do
    alias Ficdb.Directory.Bookshelf

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def bookshelf_fixture(attrs \\ %{}) do
      {:ok, bookshelf} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_bookshelf()

      bookshelf
    end

    test "list_bookshelves/0 returns all bookshelves" do
      bookshelf = bookshelf_fixture()
      assert Fanfics.list_bookshelves() == [bookshelf]
    end

    test "get_bookshelf!/1 returns the bookshelf with given id" do
      bookshelf = bookshelf_fixture()
      assert Fanfics.get_bookshelf!(bookshelf.id) == bookshelf
    end

    test "create_bookshelf/1 with valid data creates a bookshelf" do
      assert {:ok, %Bookshelf{} = bookshelf} = Fanfics.create_bookshelf(@valid_attrs)
      assert bookshelf.description == "some description"
      assert bookshelf.name == "some name"
    end

    test "create_bookshelf/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_bookshelf(@invalid_attrs)
    end

    test "update_bookshelf/2 with valid data updates the bookshelf" do
      bookshelf = bookshelf_fixture()
      assert {:ok, bookshelf} = Fanfics.update_bookshelf(bookshelf, @update_attrs)
      assert %Bookshelf{} = bookshelf
      assert bookshelf.description == "some updated description"
      assert bookshelf.name == "some updated name"
    end

    test "update_bookshelf/2 with invalid data returns error changeset" do
      bookshelf = bookshelf_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_bookshelf(bookshelf, @invalid_attrs)
      assert bookshelf == Fanfics.get_bookshelf!(bookshelf.id)
    end

    test "delete_bookshelf/1 deletes the bookshelf" do
      bookshelf = bookshelf_fixture()
      assert {:ok, %Bookshelf{}} = Fanfics.delete_bookshelf(bookshelf)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_bookshelf!(bookshelf.id) end
    end

    test "change_bookshelf/1 returns a bookshelf changeset" do
      bookshelf = bookshelf_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_bookshelf(bookshelf)
    end
  end

  describe "suggestions" do
    alias Ficdb.Fanfics.Suggestion

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def suggestion_fixture(attrs \\ %{}) do
      {:ok, suggestion} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Fanfics.create_suggestion()

      suggestion
    end

    test "list_suggestions/0 returns all suggestions" do
      suggestion = suggestion_fixture()
      assert Fanfics.list_suggestions() == [suggestion]
    end

    test "get_suggestion!/1 returns the suggestion with given id" do
      suggestion = suggestion_fixture()
      assert Fanfics.get_suggestion!(suggestion.id) == suggestion
    end

    test "create_suggestion/1 with valid data creates a suggestion" do
      assert {:ok, %Suggestion{} = suggestion} = Fanfics.create_suggestion(@valid_attrs)
      assert suggestion.content == "some content"
    end

    test "create_suggestion/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fanfics.create_suggestion(@invalid_attrs)
    end

    test "update_suggestion/2 with valid data updates the suggestion" do
      suggestion = suggestion_fixture()
      assert {:ok, suggestion} = Fanfics.update_suggestion(suggestion, @update_attrs)
      assert %Suggestion{} = suggestion
      assert suggestion.content == "some updated content"
    end

    test "update_suggestion/2 with invalid data returns error changeset" do
      suggestion = suggestion_fixture()
      assert {:error, %Ecto.Changeset{}} = Fanfics.update_suggestion(suggestion, @invalid_attrs)
      assert suggestion == Fanfics.get_suggestion!(suggestion.id)
    end

    test "delete_suggestion/1 deletes the suggestion" do
      suggestion = suggestion_fixture()
      assert {:ok, %Suggestion{}} = Fanfics.delete_suggestion(suggestion)
      assert_raise Ecto.NoResultsError, fn -> Fanfics.get_suggestion!(suggestion.id) end
    end

    test "change_suggestion/1 returns a suggestion changeset" do
      suggestion = suggestion_fixture()
      assert %Ecto.Changeset{} = Fanfics.change_suggestion(suggestion)
    end
  end
end

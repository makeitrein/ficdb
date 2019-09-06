defmodule FicdbWeb.GenreControllerTest do
  use FicdbWeb.ConnCase

  alias Ficdb.Directory

  @create_attrs %{description: "some description", image: "some image", name: "some name"}
  @update_attrs %{description: "some updated description", image: "some updated image", name: "some updated name"}
  @invalid_attrs %{description: nil, image: nil, name: nil}

  def fixture(:genre) do
    {:ok, genre} = Fanfics.create_genre(@create_attrs)
    genre
  end

  describe "index" do
    test "lists all genres", %{conn: conn} do
      conn = get conn, genre_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Genres"
    end
  end

  describe "new genre" do
    test "renders form", %{conn: conn} do
      conn = get conn, genre_path(conn, :new)
      assert html_response(conn, 200) =~ "New Genre"
    end
  end

  describe "create genre" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, genre_path(conn, :create), genre: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == genre_path(conn, :show, id)

      conn = get conn, genre_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Genre"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, genre_path(conn, :create), genre: @invalid_attrs
      assert html_response(conn, 200) =~ "New Genre"
    end
  end

  describe "edit genre" do
    setup [:create_genre]

    test "renders form for editing chosen genre", %{conn: conn, genre: genre} do
      conn = get conn, genre_path(conn, :edit, genre)
      assert html_response(conn, 200) =~ "Edit Genre"
    end
  end

  describe "update genre" do
    setup [:create_genre]

    test "redirects when data is valid", %{conn: conn, genre: genre} do
      conn = put conn, genre_path(conn, :update, genre), genre: @update_attrs
      assert redirected_to(conn) == genre_path(conn, :show, genre)

      conn = get conn, genre_path(conn, :show, genre)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, genre: genre} do
      conn = put conn, genre_path(conn, :update, genre), genre: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Genre"
    end
  end

  describe "delete genre" do
    setup [:create_genre]

    test "deletes chosen genre", %{conn: conn, genre: genre} do
      conn = delete conn, genre_path(conn, :delete, genre)
      assert redirected_to(conn) == genre_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, genre_path(conn, :show, genre)
      end
    end
  end

  defp create_genre(_) do
    genre = fixture(:genre)
    {:ok, genre: genre}
  end
end

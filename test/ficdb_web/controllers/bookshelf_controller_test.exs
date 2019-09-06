defmodule FicdbWeb.BookshelfControllerTest do
  use FicdbWeb.ConnCase

  alias Ficdb.Directory

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:bookshelf) do
    {:ok, bookshelf} = Fanfics.create_bookshelf(@create_attrs)
    bookshelf
  end

  describe "index" do
    test "lists all bookshelves", %{conn: conn} do
      conn = get conn, bookshelf_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Bookshelves"
    end
  end

  describe "new bookshelf" do
    test "renders form", %{conn: conn} do
      conn = get conn, bookshelf_path(conn, :new)
      assert html_response(conn, 200) =~ "New Bookshelf"
    end
  end

  describe "create bookshelf" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, bookshelf_path(conn, :create), bookshelf: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == bookshelf_path(conn, :show, id)

      conn = get conn, bookshelf_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Bookshelf"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, bookshelf_path(conn, :create), bookshelf: @invalid_attrs
      assert html_response(conn, 200) =~ "New Bookshelf"
    end
  end

  describe "edit bookshelf" do
    setup [:create_bookshelf]

    test "renders form for editing chosen bookshelf", %{conn: conn, bookshelf: bookshelf} do
      conn = get conn, bookshelf_path(conn, :edit, bookshelf)
      assert html_response(conn, 200) =~ "Edit Bookshelf"
    end
  end

  describe "update bookshelf" do
    setup [:create_bookshelf]

    test "redirects when data is valid", %{conn: conn, bookshelf: bookshelf} do
      conn = put conn, bookshelf_path(conn, :update, bookshelf), bookshelf: @update_attrs
      assert redirected_to(conn) == bookshelf_path(conn, :show, bookshelf)

      conn = get conn, bookshelf_path(conn, :show, bookshelf)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, bookshelf: bookshelf} do
      conn = put conn, bookshelf_path(conn, :update, bookshelf), bookshelf: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Bookshelf"
    end
  end

  describe "delete bookshelf" do
    setup [:create_bookshelf]

    test "deletes chosen bookshelf", %{conn: conn, bookshelf: bookshelf} do
      conn = delete conn, bookshelf_path(conn, :delete, bookshelf)
      assert redirected_to(conn) == bookshelf_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, bookshelf_path(conn, :show, bookshelf)
      end
    end
  end

  defp create_bookshelf(_) do
    bookshelf = fixture(:bookshelf)
    {:ok, bookshelf: bookshelf}
  end
end

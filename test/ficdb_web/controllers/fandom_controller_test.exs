defmodule FicdbWeb.FandomControllerTest do
  use FicdbWeb.ConnCase

  alias Ficdb.Directory

  @create_attrs %{author: "some author", description: "some description", image: "some image", name: "some name", url: "some url"}
  @update_attrs %{author: "some updated author", description: "some updated description", image: "some updated image", name: "some updated name", url: "some updated url"}
  @invalid_attrs %{author: nil, description: nil, image: nil, name: nil, url: nil}

  def fixture(:fandom) do
    {:ok, fandom} = Fanfics.create_fandom(@create_attrs)
    fandom
  end

  describe "index" do
    test "lists all fandoms", %{conn: conn} do
      conn = get conn, fandom_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Fandoms"
    end
  end

  describe "new fandom" do
    test "renders form", %{conn: conn} do
      conn = get conn, fandom_path(conn, :new)
      assert html_response(conn, 200) =~ "New Fandom"
    end
  end

  describe "create fandom" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, fandom_path(conn, :create), fandom: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == fandom_path(conn, :show, id)

      conn = get conn, fandom_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Fandom"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, fandom_path(conn, :create), fandom: @invalid_attrs
      assert html_response(conn, 200) =~ "New Fandom"
    end
  end

  describe "edit fandom" do
    setup [:create_fandom]

    test "renders form for editing chosen fandom", %{conn: conn, fandom: fandom} do
      conn = get conn, fandom_path(conn, :edit, fandom)
      assert html_response(conn, 200) =~ "Edit Fandom"
    end
  end

  describe "update fandom" do
    setup [:create_fandom]

    test "redirects when data is valid", %{conn: conn, fandom: fandom} do
      conn = put conn, fandom_path(conn, :update, fandom), fandom: @update_attrs
      assert redirected_to(conn) == fandom_path(conn, :show, fandom)

      conn = get conn, fandom_path(conn, :show, fandom)
      assert html_response(conn, 200) =~ "some updated author"
    end

    test "renders errors when data is invalid", %{conn: conn, fandom: fandom} do
      conn = put conn, fandom_path(conn, :update, fandom), fandom: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Fandom"
    end
  end

  describe "delete fandom" do
    setup [:create_fandom]

    test "deletes chosen fandom", %{conn: conn, fandom: fandom} do
      conn = delete conn, fandom_path(conn, :delete, fandom)
      assert redirected_to(conn) == fandom_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, fandom_path(conn, :show, fandom)
      end
    end
  end

  defp create_fandom(_) do
    fandom = fixture(:fandom)
    {:ok, fandom: fandom}
  end
end

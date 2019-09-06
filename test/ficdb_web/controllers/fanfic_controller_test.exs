defmodule FicdbWeb.FanficControllerTest do
  use FicdbWeb.ConnCase

  alias Ficdb.Directory

  @create_attrs %{description: "some description", first_chapter_at: "2010-04-17 14:00:00.000000Z", is_completed: true, is_one_shot: true, last_chapter_at: "2010-04-17 14:00:00.000000Z", name: "some name", status: "some status", urls: [], word_count: 42}
  @update_attrs %{description: "some updated description", first_chapter_at: "2011-05-18 15:01:01.000000Z", is_completed: false, is_one_shot: false, last_chapter_at: "2011-05-18 15:01:01.000000Z", name: "some updated name", status: "some updated status", urls: [], word_count: 43}
  @invalid_attrs %{description: nil, first_chapter_at: nil, is_completed: nil, is_one_shot: nil, last_chapter_at: nil, name: nil, status: nil, urls: nil, word_count: nil}

  def fixture(:fanfic) do
    {:ok, fanfic} = Fanfics.create_fanfic(@create_attrs)
    fanfic
  end

  describe "index" do
    test "lists all fanfics", %{conn: conn} do
      conn = get conn, fanfic_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Fanfics"
    end
  end

  describe "new fanfic" do
    test "renders form", %{conn: conn} do
      conn = get conn, fanfic_path(conn, :new)
      assert html_response(conn, 200) =~ "New Fanfic"
    end
  end

  describe "create fanfic" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, fanfic_path(conn, :create), fanfic: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == fanfic_path(conn, :show, id)

      conn = get conn, fanfic_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Fanfic"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, fanfic_path(conn, :create), fanfic: @invalid_attrs
      assert html_response(conn, 200) =~ "New Fanfic"
    end
  end

  describe "edit fanfic" do
    setup [:create_fanfic]

    test "renders form for editing chosen fanfic", %{conn: conn, fanfic: fanfic} do
      conn = get conn, fanfic_path(conn, :edit, fanfic)
      assert html_response(conn, 200) =~ "Edit Fanfic"
    end
  end

  describe "update fanfic" do
    setup [:create_fanfic]

    test "redirects when data is valid", %{conn: conn, fanfic: fanfic} do
      conn = put conn, fanfic_path(conn, :update, fanfic), fanfic: @update_attrs
      assert redirected_to(conn) == fanfic_path(conn, :show, fanfic)

      conn = get conn, fanfic_path(conn, :show, fanfic)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, fanfic: fanfic} do
      conn = put conn, fanfic_path(conn, :update, fanfic), fanfic: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Fanfic"
    end
  end

  describe "delete fanfic" do
    setup [:create_fanfic]

    test "deletes chosen fanfic", %{conn: conn, fanfic: fanfic} do
      conn = delete conn, fanfic_path(conn, :delete, fanfic)
      assert redirected_to(conn) == fanfic_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, fanfic_path(conn, :show, fanfic)
      end
    end
  end

  defp create_fanfic(_) do
    fanfic = fixture(:fanfic)
    {:ok, fanfic: fanfic}
  end
end

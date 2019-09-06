defmodule FicdbWeb.ChapterControllerTest do
  use FicdbWeb.ConnCase

  alias Ficdb.Directory

  @create_attrs %{posted_at: "2010-04-17 14:00:00.000000Z", reactions: 42, url: "some url"}
  @update_attrs %{posted_at: "2011-05-18 15:01:01.000000Z", reactions: 43, url: "some updated url"}
  @invalid_attrs %{posted_at: nil, reactions: nil, url: nil}

  def fixture(:chapter) do
    {:ok, chapter} = Fanfics.create_chapter(@create_attrs)
    chapter
  end

  describe "index" do
    test "lists all chapters", %{conn: conn} do
      conn = get conn, chapter_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Chapters"
    end
  end

  describe "new chapter" do
    test "renders form", %{conn: conn} do
      conn = get conn, chapter_path(conn, :new)
      assert html_response(conn, 200) =~ "New Chapter"
    end
  end

  describe "create chapter" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, chapter_path(conn, :create), chapter: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == chapter_path(conn, :show, id)

      conn = get conn, chapter_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Chapter"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, chapter_path(conn, :create), chapter: @invalid_attrs
      assert html_response(conn, 200) =~ "New Chapter"
    end
  end

  describe "edit chapter" do
    setup [:create_chapter]

    test "renders form for editing chosen chapter", %{conn: conn, chapter: chapter} do
      conn = get conn, chapter_path(conn, :edit, chapter)
      assert html_response(conn, 200) =~ "Edit Chapter"
    end
  end

  describe "update chapter" do
    setup [:create_chapter]

    test "redirects when data is valid", %{conn: conn, chapter: chapter} do
      conn = put conn, chapter_path(conn, :update, chapter), chapter: @update_attrs
      assert redirected_to(conn) == chapter_path(conn, :show, chapter)

      conn = get conn, chapter_path(conn, :show, chapter)
      assert html_response(conn, 200) =~ "some updated url"
    end

    test "renders errors when data is invalid", %{conn: conn, chapter: chapter} do
      conn = put conn, chapter_path(conn, :update, chapter), chapter: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Chapter"
    end
  end

  describe "delete chapter" do
    setup [:create_chapter]

    test "deletes chosen chapter", %{conn: conn, chapter: chapter} do
      conn = delete conn, chapter_path(conn, :delete, chapter)
      assert redirected_to(conn) == chapter_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, chapter_path(conn, :show, chapter)
      end
    end
  end

  defp create_chapter(_) do
    chapter = fixture(:chapter)
    {:ok, chapter: chapter}
  end
end

defmodule FicdbWeb.SuggestionControllerTest do
  use FicdbWeb.ConnCase

  alias Ficdb.Fanfics

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  def fixture(:suggestion) do
    {:ok, suggestion} = Fanfics.create_suggestion(@create_attrs)
    suggestion
  end

  describe "index" do
    test "lists all suggestions", %{conn: conn} do
      conn = get conn, suggestion_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Suggestions"
    end
  end

  describe "new suggestion" do
    test "renders form", %{conn: conn} do
      conn = get conn, suggestion_path(conn, :new)
      assert html_response(conn, 200) =~ "New Suggestion"
    end
  end

  describe "create suggestion" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, suggestion_path(conn, :create), suggestion: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == suggestion_path(conn, :show, id)

      conn = get conn, suggestion_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Suggestion"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, suggestion_path(conn, :create), suggestion: @invalid_attrs
      assert html_response(conn, 200) =~ "New Suggestion"
    end
  end

  describe "edit suggestion" do
    setup [:create_suggestion]

    test "renders form for editing chosen suggestion", %{conn: conn, suggestion: suggestion} do
      conn = get conn, suggestion_path(conn, :edit, suggestion)
      assert html_response(conn, 200) =~ "Edit Suggestion"
    end
  end

  describe "update suggestion" do
    setup [:create_suggestion]

    test "redirects when data is valid", %{conn: conn, suggestion: suggestion} do
      conn = put conn, suggestion_path(conn, :update, suggestion), suggestion: @update_attrs
      assert redirected_to(conn) == suggestion_path(conn, :show, suggestion)

      conn = get conn, suggestion_path(conn, :show, suggestion)
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, suggestion: suggestion} do
      conn = put conn, suggestion_path(conn, :update, suggestion), suggestion: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Suggestion"
    end
  end

  describe "delete suggestion" do
    setup [:create_suggestion]

    test "deletes chosen suggestion", %{conn: conn, suggestion: suggestion} do
      conn = delete conn, suggestion_path(conn, :delete, suggestion)
      assert redirected_to(conn) == suggestion_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, suggestion_path(conn, :show, suggestion)
      end
    end
  end

  defp create_suggestion(_) do
    suggestion = fixture(:suggestion)
    {:ok, suggestion: suggestion}
  end
end

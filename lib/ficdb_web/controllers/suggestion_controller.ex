defmodule FicdbWeb.SuggestionController do
  use FicdbWeb, :controller
  use Breadcrumble

  plug :add_breadcrumb, name: "Suggestions", url: "/" <> "suggestions"
  plug FicdbWeb.Plugs.Veil.Authenticate when action not in [:index, :show]
  plug FicdbWeb.Plugs.Authenticate when action not in [:index, :show]

  alias Ficdb.SchemaHelpers
  alias Ficdb.Authorization
  alias Ficdb.Repo
  alias Ficdb.Directory
  alias Ficdb.Directory.{Genre, Suggestion}

  def genre_dropdown_options,
      do: Genre
          |> SchemaHelpers.ordered_by_query
          |> SchemaHelpers.dropdown_format_query
          |> Repo.all

  def index(conn, _params) do
    suggestions = Directory.list_suggestions()
    changeset = Directory.change_suggestion(%Suggestion{genres: []})
    render(conn, "index.html", suggestions: suggestions, changeset: changeset, genre_dropdown_options: genre_dropdown_options)
  end

  def new(conn, _params) do
    changeset = Directory.change_suggestion(%Suggestion{genres: []})
    add_breadcrumb(conn, name: "New", url: suggestion_path(conn, :new))
    |> render("new.html", changeset: changeset, genre_dropdown_options: genre_dropdown_options)
  end


  def create(conn, %{"suggestion" => suggestion_params}) do
    redirect_path = case suggestion_params["fanfic_id"] do
      "" -> suggestion_path(conn, :index)
      _ -> fanfic_path(conn, :show, suggestion_params["fanfic_id"])
    end

    case Directory.create_suggestion(Authorization.merge_submitter_id(suggestion_params, conn)) do
      {:ok, suggestion} ->
        conn
        |> put_flash(:info, "Suggestion created successfully.")
        |> redirect(to: redirect_path)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Suggestion failed to create.")
        |> redirect(to: redirect_path)
    end
  end

  def show(conn, %{"id" => id}) do
    suggestion = Directory.get_suggestion!(id)
    
    add_breadcrumb(conn, name: suggestion.id, url: suggestion_path(conn, :show, suggestion))
    |> render("show.html", suggestion: suggestion)
  end

  def edit(conn, %{"id" => id}) do
    suggestion = Directory.get_suggestion!(id)
    
    changeset = Directory.change_suggestion(suggestion)
    add_breadcrumb(conn, name: suggestion.id, url: suggestion_path(conn, :show, suggestion))
    |> add_breadcrumb(name: "Edit", url: suggestion_path(conn, :edit, suggestion))
    |> render("edit.html", suggestion: suggestion, changeset: changeset)
  end

  def update(conn, %{"id" => id, "suggestion" => suggestion_params}) do
    suggestion = Directory.get_suggestion!(id)

    case Directory.update_suggestion(suggestion, suggestion_params) do
      {:ok, suggestion} ->
        conn
        |> put_flash(:info, "Suggestion updated successfully.")
        |> redirect(to: suggestion_path(conn, :show, suggestion))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", suggestion: suggestion, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    suggestion = Directory.get_suggestion!(id)
    {:ok, _suggestion} = Directory.delete_suggestion(suggestion)

    conn
    |> put_flash(:info, "Suggestion deleted successfully.")
    |> redirect(to: suggestion_path(conn, :index))
  end
end

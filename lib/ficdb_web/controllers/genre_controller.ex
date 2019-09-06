defmodule FicdbWeb.GenreController do
  use FicdbWeb, :controller
  use Breadcrumble

  plug :add_breadcrumb, name: "Genres", url: "/" <> "genres"
  plug FicdbWeb.Plugs.VerifyRole, [:admin, :mod] when action not in [:index, :show]

  alias Ficdb.Authorization
  alias Ficdb.Directory
  alias Ficdb.Directory.{Genre, Fandom}
  alias Ficdb.SchemaHelpers
  alias Ficdb.Repo

  def fandom_dropdown_options,
      do: Fandom
          |> SchemaHelpers.dropdown_format_query
          |> SchemaHelpers.ordered_by_query
          |> Repo.all

  def index(conn, _params) do
    genres = Genre |> SchemaHelpers.ordered_by_query |> Genre.with_fandom_query |> Genre.with_fanfic_count_query |> Repo.all
    genres_by_type = genres |> Enum.group_by(fn genre -> genre.genre_type || genre.fandom && genre.fandom.name end)
    render(conn, "index.html", genres_by_type: genres_by_type)
  end


  def new(conn, _params) do
    changeset = Directory.change_genre(%Genre{})
    add_breadcrumb(conn, name: "New", url: genre_path(conn, :new))
    |> render("new.html", changeset: changeset, fandom_dropdown_options: fandom_dropdown_options)
  end


  def create(conn, %{"genre" => genre_params}) do
    case Directory.create_genre(Authorization.merge_submitter_id(genre_params, conn)) do
      {:ok, genre} ->
        conn
        |> put_flash(:info, "Genre created successfully.")
        |> redirect(to: genre_path(conn, :show, genre))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, fandom_dropdown_options: fandom_dropdown_options)
    end
  end

  def show(conn, %{"id" => id}) do
    genre = Directory.get_genre!(id)
    add_breadcrumb(conn, name: genre.name, url: genre_path(conn, :show, genre))
    |> render("show.html", genre: genre)
  end

  def edit(conn, %{"id" => id}) do
    genre = Directory.get_genre!(id)
    changeset = Directory.change_genre(genre)
    add_breadcrumb(conn, name: genre.name, url: genre_path(conn, :show, genre))
    |> add_breadcrumb(name: "Edit", url: genre_path(conn, :edit, genre))
    |> render("edit.html", genre: genre, changeset: changeset, fandom_dropdown_options: fandom_dropdown_options)
  end

  def update(conn, %{"id" => id, "genre" => genre_params}) do
    genre = Directory.get_genre!(id)

    case Directory.update_genre(genre, Authorization.merge_updater_id(genre_params, conn)) do
      {:ok, genre} ->
        conn
        |> put_flash(:info, "Genre updated successfully.")
        |> redirect(to: genre_path(conn, :show, genre))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", genre: genre, changeset: changeset, fandom_dropdown_options: fandom_dropdown_options)
    end
  end

  def delete(conn, %{"id" => id}) do
    genre = Directory.get_genre!(id)
    {:ok, _genre} = Directory.delete_genre(genre)

    conn
    |> put_flash(:info, "Genre deleted successfully.")
    |> redirect(to: genre_path(conn, :index))
  end
end

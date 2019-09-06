defmodule FicdbWeb.FandomController do
  use FicdbWeb, :controller
  use Breadcrumble

  plug :add_breadcrumb, name: "Fandoms", url: "/" <> "fandoms"
  plug FicdbWeb.Plugs.VerifyRole, [:admin, :mod] when action not in [:index, :show]

  alias Ficdb.Authorization
  alias Ficdb.Repo
  alias Ficdb.Directory
  alias Ficdb.Directory.{Fandom, Character}
  alias Ficdb.SchemaHelpers

  defp params_with_parsed_characters(params) do
    current_characters = Map.get(params, "characters", %{})
    bulk_characters = params["characters_bulk"] |> String.trim() |> String.split("\n", trim: true) |> Enum.map(fn name -> %{name: name} end) |> Enum.with_index(1) |>Enum.map(fn {k,v}->{v,k} end) |> Map.new
    characters = Map.merge(current_characters, bulk_characters)
    Map.merge(params, %{"characters" => characters})
  end

  def index(conn, _params) do
    fandoms = Fandom |> SchemaHelpers.ordered_by_query |> Fandom.with_fanfic_count_query |> Repo.all
    fandoms_by_type = fandoms |> Enum.group_by(&(&1.fandom_type))

    render(conn, "index.html", fandoms_by_type: fandoms_by_type)
  end

  def new(conn, _params) do
    changeset = Directory.change_fandom(%Fandom{characters: []})
    add_breadcrumb(conn, name: "New", url: fandom_path(conn, :new))
    |> render("new.html", changeset: changeset)
  end


  def create(conn, %{"fandom" => fandom_params}) do

    case Directory.create_fandom(Authorization.merge_submitter_id(params_with_parsed_characters(fandom_params), conn)) do
      {:ok, fandom} ->
        conn
        |> put_flash(:info, "Fandom created successfully.")
        |> redirect(to: fandom_path(conn, :show, fandom))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    fandom = Directory.get_fandom!(id)
    name_or_id = fandom.name || fandom.id
    add_breadcrumb(conn, name: name_or_id, url: fandom_path(conn, :show, fandom))
    |> render("show.html", fandom: fandom)
  end

  def edit(conn, %{"id" => id}) do
    fandom = Directory.get_fandom!(id)
    name_or_id = fandom.name || fandom.id
    changeset = Directory.change_fandom(fandom)
    add_breadcrumb(conn, name: name_or_id, url: fandom_path(conn, :show, fandom))
    |> add_breadcrumb(name: "Edit", url: fandom_path(conn, :edit, fandom))
    |> render("edit.html", fandom: fandom, changeset: changeset)
  end

  def update(conn, %{"id" => id, "fandom" => fandom_params}) do
    fandom = Directory.get_fandom!(id)

    case Directory.update_fandom(fandom, Authorization.merge_updater_id(params_with_parsed_characters(fandom_params), conn)) do
      {:ok, fandom} ->
        conn
        |> put_flash(:info, "Fandom updated successfully.")
        |> redirect(to: fandom_path(conn, :show, fandom))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", fandom: fandom, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fandom = Directory.get_fandom!(id)
    {:ok, _fandom} = Directory.delete_fandom(fandom)

    conn
    |> put_flash(:info, "Fandom deleted successfully.")
    |> redirect(to: fandom_path(conn, :index))
  end
end

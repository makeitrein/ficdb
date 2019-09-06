defmodule FicdbWeb.CharacterController do
  use FicdbWeb, :controller

  use Breadcrumble

  plug FicdbWeb.Plugs.VerifyRole, [:admin, :mod] when action not in [:index, :show]
  plug :add_breadcrumb, name: "Characters", url: "/" <> "characters"

  alias Ficdb.Directory
  alias Ficdb.Repo
  alias Ficdb.SchemaHelpers
  alias Ficdb.Directory.Character

  def index(conn, _params) do
    characters = Directory.list_characters()
    render(conn, "index.html", characters: characters)
  end

  def new(conn, _params) do
    changeset = Directory.change_character(%Character{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"character" => character_params}) do
    case Directory.create_character(character_params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character created successfully.")
        |> redirect(to: character_path(conn, :show, character))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    character = Directory.get_character!(id)
    render(conn, "show.html", character: character)
  end

  def edit(conn, %{"id" => id}) do
    character = Directory.get_character!(id)
    changeset = Directory.change_character(character)
    render(conn, "edit.html", character: character, changeset: changeset)
  end

  def update(conn, %{"id" => id, "character" => character_params}) do
    character = Directory.get_character!(id)

    case Directory.update_character(character, character_params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character updated successfully.")
        |> redirect(to: character_path(conn, :show, character))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", character: character, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    character = Directory.get_character!(id)
    {:ok, _character} = Directory.delete_character(character)

    conn
    |> put_flash(:info, "Character deleted successfully.")
    |> redirect(to: character_path(conn, :index))
  end

  def crawl_characters(conn, %{"fandom_ids" => fandom_ids}) do
    fandom_ids= Poison.decode!(fandom_ids)
    characters = Character
    |> Character.from_fandom_query(fandom_ids)
    |> SchemaHelpers.ordered_by_query()
    |> SchemaHelpers.selectize_format_query
    |> Repo.all

    conn |> json(characters)
  end
end

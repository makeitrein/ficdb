defmodule FicdbWeb.BookshelfController do
  use FicdbWeb, :controller

  plug FicdbWeb.Plugs.Authenticate when action not in [:index, :show]

  alias Ficdb.Repo
  alias Ficdb.Directory
  alias Ficdb.Directory.Fandom
  alias Ficdb.SchemaHelpers
  alias Ficdb.Authorization


  def add_to_bookshelf(conn, %{"fanfic_id" => fanfic_id, "bookshelf_id" => bookshelf_id}) do
    current_user_id = Authorization.current_user_id(conn)
    search_params = %{fanfic_id: fanfic_id, submitter_id: current_user_id}
    create_params = %{fanfic_id: fanfic_id, submitter_id: current_user_id, bookshelf_id: bookshelf_id}
    update_params = %{bookshelf_id: bookshelf_id}

    fanfic_bookshelf = Directory.get_by_fanfics_bookshelves(search_params)

    create_bookshelf =  bookshelf_id != "" and !fanfic_bookshelf
    delete_bookshelf = fanfic_bookshelf && (bookshelf_id == fanfic_bookshelf.bookshelf_id |> Integer.to_string)
    update_bookshelf = bookshelf_id != "" and fanfic_bookshelf

      result = cond do
        create_bookshelf -> Directory.create_fanfics_bookshelves(create_params)
        delete_bookshelf -> Directory.delete_fanfics_bookshelves(search_params)
        update_bookshelf -> Directory.update_fanfics_bookshelves(fanfic_bookshelf, update_params)
      end


      text = cond do
        create_bookshelf -> "create_bookshelf"
        delete_bookshelf -> "delete_bookshelf"
        update_bookshelf -> "update_bookshelf"
      end

      case result do
        {:ok, review} ->
          text conn, text
        {:error, %Ecto.Changeset{} = changeset} ->
          nil
      end

    end

end


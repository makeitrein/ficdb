defmodule FicdbWeb.Plugs.VerifyOwnerOrRole do
  @moduledoc """
  A plug to restrict access to users with particular roles
  """
  import Plug.Conn
  import Phoenix.Controller
  alias Ficdb.Directory
  alias Ficdb.Directory.{Fanfic, Fandom, Review, Genre, Bookshelf}
  alias Ficdb.Authorization

  defp not_permitted(conn), do: conn |> put_flash(:info, "Sorry, you're not authorized to do that!") |> redirect(to: "/") |> halt()

  def init(default), do: default

  def call(%Plug.Conn{params: %{"id" => id}} = conn, :fanfic) do
    fanfic = Directory.get_fanfic!(id, Authorization.current_user_id(conn))
    case Ficdb.Authorization.verify_owner_or_role(conn, Authorization.submitter_id(fanfic), [:admin, :mod]) do
      {:ok} -> assign(conn, :fanfic, fanfic)
      _ ->  not_permitted conn
    end
  end

  def call(%Plug.Conn{params: %{"id" => id}} = conn, :review) do
    review = Directory.get_review!(id)
    case Ficdb.Authorization.verify_owner_or_role(conn, Authorization.submitter_id(review), [:admin, :mod]) do
      {:ok} -> assign(conn, :review, review)
      _ ->  not_permitted conn
    end
  end

  def call(%Plug.Conn{params: %{"id" => id}} = conn, :genre) do
    genre = Directory.get_genre!(id)
    case Ficdb.Authorization.verify_owner_or_role(conn, Authorization.submitter_id(genre), [:admin, :mod]) do
      {:ok} -> assign(conn, :genre, genre)
      _ ->  not_permitted conn
    end
  end

  def call(%Plug.Conn{params: %{"id" => id}} = conn, :fandom) do
    fandom = Directory.get_fandom!(id)
    case Ficdb.Authorization.verify_owner_or_role(conn, Authorization.submitter_id(fandom), [:admin, :mod]) do
      {:ok} -> assign(conn, :fandom, fandom)
      _ ->  not_permitted conn
    end
  end

end

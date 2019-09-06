defmodule FicdbWeb.AdminController do
  use FicdbWeb, :controller
  use Breadcrumble

  alias Ficdb.Veil
  alias Ficdb.Veil.User
  alias Ficdb.Directory.{Fanfic, Review, Bookshelf}
  alias Ficdb.DateHelpers
  alias Ficdb.SchemaHelpers
  alias Ficdb.Authorization


  alias Ficdb.Repo

  plug FicdbWeb.Plugs.VerifyRole, [:admin, :mod]

  def users(conn, _params) do
    add_breadcrumb(conn, name: "Users", url: "/")
    |> render("user_admin.html", users: Veil.get_all_users())
  end

  def make_submitter(conn, %{"id" => user_id}) do
    user = Veil.get_user(user_id)
    case Veil.update_user(user, %{role: :submitter}) do
      {:ok, _user} -> send_resp(conn, 200, "")
      {:error, %Ecto.Changeset{} = changeset} -> send_resp(conn, 500, "")
    end
  end

  def make_mod(conn, %{"id" => user_id}) do
    user = Veil.get_user(user_id)
    case Veil.update_user(user, %{role: :mod}) do
      {:ok, _user} -> send_resp(conn, 200, "")
      {:error, %Ecto.Changeset{} = changeset} -> send_resp(conn, 500, "")
    end
  end

  def make_banned(conn, %{"id" => user_id}) do
    user = Veil.get_user(user_id)
    case Veil.update_user(user, %{role: :banned}) do
      {:ok, _user} -> send_resp(conn, 200, "")
      {:error, %Ecto.Changeset{} = changeset} -> send_resp(conn, 500, "")
    end
  end

end

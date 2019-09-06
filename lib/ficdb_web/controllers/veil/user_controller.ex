defmodule FicdbWeb.Veil.UserController do
  use FicdbWeb, :controller
  use Breadcrumble

  alias Ficdb.Veil
  alias Ficdb.Veil.User
  alias Ficdb.Directory.{Fanfic, Review, Bookshelf}
  alias Ficdb.DateHelpers
  alias Ficdb.Authorization


  alias Ficdb.Repo

  action_fallback(FicdbWeb.Veil.FallbackController)

  #  plug :put_layout, :account_layout when action in [:show, :reviews, :bookshelves]

  plug(:scrub_params, "user" when action in [:create])



  def user_bookshelves(user_id),
      do: Bookshelf
          |> Bookshelf.user_bookshelves_query(user_id)
          |> Repo.all

  @doc """
  Shows the sign in form
  """
  def new(conn, _params) do
    add_breadcrumb(conn, name: "Auth", url: user_path(conn, :new))
    |> render("new.html", changeset: User.changeset(%User{}))
  end


  def show(conn, params) do
    user_id = params["id"] || Authorization.current_user_id(conn)
    is_my_account = !params["id"] || String.to_integer(params["id"]) == Authorization.current_user_id(conn)
    user = Veil.get_user(user_id)
    changeset = is_my_account && Veil.change_user(user)
    start = DateHelpers.now_microseconds

    add_breadcrumb(
      conn,
      name: "Account",
      url: user_path(conn, :show)
    )
    |> render(
         "account.html",
         changeset: changeset,
         user_bookshelves: user_bookshelves(user_id),
         user_id: user_id,
         user: user,
         is_my_account: is_my_account,
         benchmark: DateHelpers.now_microseconds - start
       )
  end

  def update(conn, %{"user" => user_params}) do
    user = Veil.get_user(Authorization.current_user_id(conn))

    case Veil.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Invalid Image. Only .jpg, .jpeg, .gif, and .png files under 250kb without special characters or spaces allowed.")
        |> redirect(to: user_path(conn, :show))
    end
  end


  @doc """
  If needed, creates a new user, otherwise finds the existing one.
  Creates a new request and emails the unique id to the user.
  """

  def signup(
        conn,
        %{
          "user" => %{
            "email" => email,
            "username" => username
          }
        }
      ) when not is_nil(email) and not is_nil(username) do

    with {:ok, user} <- Veil.create_user(email, username) do
      sign_and_email(conn, user)
    else
      error ->
        error
    end

  end

  def login(
        conn,
        %{
          "user" => %{
            "email" => email
          }
        }
      ) when not is_nil(email) do

    if user = Veil.get_user_by_email(email) do
      sign_and_email(conn, user)
    end

  end

  defp sign_and_email(conn, %User{} = user) do
    with {:ok, request} <- Veil.create_request(conn, user),
         {:ok, email} <- Veil.send_login_email(conn, user, request) do

      add_breadcrumb(conn, name: "Auth", url: user_path(conn, :new))
      |> add_breadcrumb(name: "Check Your Email")
      |> render("show.html", user: user, email: email)

    else
      error ->
        error
    end
  end
end
defmodule FicdbWeb.Veil.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  require Logger
  use FicdbWeb, :controller
  alias Ficdb.Veil.User
#
#  def call(conn, {:error, {:closed, ""}}) do
#    Logger.error(fn -> "[Veil] Invalid Swoosh api key, update your config.exs" end)
#
#    render(conn, FicdbWeb.Veil.UserView, "new.html", changeset: User.changeset(%User{}))
#
#  end
#
#  def call(conn, {:error, :no_permission}) do
#    Logger.error(fn -> "[Veil] Invalid Request or Session" end)
#
#    render(conn, FicdbWeb.Veil.UserView, "new.html", changeset: User.changeset(%User{}))
#
#  end

  def call(conn, error) do
    IO.inspect("USER ERROR #{error}")
    conn
    |> put_flash(:error, "There was an error! Probably your email is malformed or your username is taken.")
    |> render(FicdbWeb.Veil.UserView, "new.html", changeset: User.changeset(%User{}))

  end

end

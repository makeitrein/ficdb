defmodule FicdbWeb.Plugs.Authenticate do
  @moduledoc """
  A plug to restrict access to users with particular roles
  """
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _roles) do
    case Ficdb.Authorization.authenticate(conn) do
      {:ok, conn} -> conn
      _ ->  conn |> put_flash(:info, "Sorry, you're not authorized to do that!") |> redirect(to: "/") |> halt()
    end
  end

end

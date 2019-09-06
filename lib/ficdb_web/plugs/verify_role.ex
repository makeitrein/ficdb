defmodule FicdbWeb.Plugs.VerifyRole do
  @moduledoc """
  A plug to restrict access to users with particular roles
  """
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, roles) do
    case Ficdb.Authorization.verify_role(conn, roles) do
      {:ok} -> conn
      _ ->  conn |> put_flash(:info, "Sorry, you're not authorized to do that! Please login or sign up!") |> redirect(to: "/") |> halt()
    end
  end
end

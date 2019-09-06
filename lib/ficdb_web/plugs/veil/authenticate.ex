defmodule FicdbWeb.Plugs.Veil.Authenticate do
  @moduledoc """
  A plug to restrict access to logged in users
  We simply check to see if the user has the :veil_user_id assign set
  """
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    unless is_nil(conn.assigns[:veil_user_id]) do
      conn
    else
      
      Phoenix.Controller.redirect(conn, to: FicdbWeb.Router.Helpers.user_path(conn, :new))
      
    end
  end
end

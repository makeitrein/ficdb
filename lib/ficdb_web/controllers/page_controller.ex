defmodule FicdbWeb.PageController do
  use FicdbWeb, :controller
  use Breadcrumble

  def faq(conn, _params) do
    add_breadcrumb(conn, name: "FAQ", url: page_path(conn, :faq))
    |> render("faq.html")
  end

  def changelog(conn, _params) do
    add_breadcrumb(conn, name: "Changelog", url: page_path(conn, :changelog))
    |> render("changelog.html")
  end
end

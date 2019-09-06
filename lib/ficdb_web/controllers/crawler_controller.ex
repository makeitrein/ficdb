defmodule FicdbWeb.CrawlerController do
  use FicdbWeb, :controller
  use Breadcrumble

  require Logger

  alias Ficdb.{Directory, Repo, SchemaHelpers, DateHelpers, EnumHelpers, Authorization}
  alias Ficdb.Directory.{Fanfic, Fandom, Review, Genre, Bookshelf, Character}

  def crawl_fanfic(conn, %{"host" => host, "id" => id}) do
    with {:ok, json} <- Ficdb.FanficCrawler.fanfic_changeset(id, String.to_atom(host)) do
      conn |> json(json)
    else
      err -> IO.inspect({:crawl_fanfic_error, host, id})
    end
    end

  def crawl_fandom(conn, %{"url" => url}) do

    with {:ok, json} <- Ficdb.FandomCrawler.main(url) do
      conn |> json(json)
      else
      err -> IO.inspect({:crawl_fandom_error, url})
    end
  end
end

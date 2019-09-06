defmodule Ficdb.FandomCrawler do

  import Floki, only: [find: 2, attribute: 2, text: 1]
  alias Ficdb.Directory
  alias Ficdb.Directory.Fanfic

  def get_html(url),
      do: url
          |> HTTPoison.get([], follow_redirect: true)
          |> parse_html

  def characters(html) do
    select = find(html, "[title='character 1 filter'] option") |> Enum.map(&(text)/1) |> Enum.filter(&(filter_out)/1)
  end

  def filter_out(text) do
    !String.contains?(text, ["All Characters", "OC", "SI"])
  end

  def parse_html({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: body



  def main(url) do
    html = get_html(url)
    characters = characters(html)
    {:ok, characters}
  end

end




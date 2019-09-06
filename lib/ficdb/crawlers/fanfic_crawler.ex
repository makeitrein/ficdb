defmodule Ficdb.FanficCrawler do

  import Floki, only: [find: 2, attribute: 2, text: 1]
  alias Ficdb.{Directory, Repo}
  alias Ficdb.Directory.{Fanfic, Fandom}
  import Logger


  # START HELPERS
  def parse_list(found = [_ | _]) when is_list(found), do: {:ok, found}
  def parse_list(found = []) when is_list(found), do: {:error, "found must be a non-empty list"}
  def parse_list(nil), do: {:error, "found is required"}

  def parse_html({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: {:ok, body}
  def parse_html({:error, %HTTPoison.Response{status_code: 404}}), do: {:error, 'parse_html 404', 404}
  def parse_html({:error, %HTTPoison.Error{reason: reason}}), do: {:error, 'parse_html HTTPoision error', reason}

  def parse_text(nil), do: {:error, "text must not be nil"}
  def parse_text(""), do: {:error, "text must have text"}
  def parse_text(text) when is_bitstring(text), do: {:ok, text}

  def parse_get(nil), do: {:error, "nothing found in repo"}
  def parse_get(found_result), do: {:ok, found_result}

  def safe_find(html, selector),
      do: html
          |> find(selector)
          |> parse_list
  def safe_text(html),
      do: html
          |> text
          |> parse_text
  def safe_attribute(html, selector),
      do: html
          |> attribute(selector)
          |> parse_list

  def safe_http_get(url),
      do: url
          |> HTTPoison.get([], follow_redirect: true)
          |> parse_html


  def remove_commas(str), do:
    Regex.replace(~r/\,/, str, "")
  #END HELPERS


  def author_name(html, :sb) do
    with {:ok, list} <- safe_find(html, ".username"),
         {:ok, name} <- safe_text(list)
      do
      {:ok, name}
    else
      err -> {:error, 'author_name error', err}
    end
  end

  def author_name(html, :ff) do
    with {:ok, list} <- safe_find(html, "#profile_top a"),
         {:ok, count} <- Enum.fetch(list, 0),
         {:ok, name} <- safe_text(count)
      do
      {:ok, name}
    else
      err -> {:error, 'author_name error', err}
    end
  end

  def author_name(html, :ao3) do
    with {:ok, list} <- safe_find(html, "[rel='author']"),
         {:ok, name} <- safe_text(list)
      do
      {:ok, name}
    else
      err -> {:error, 'author_name error', err}
    end
  end

  def name(html, :sb) do
    with {:ok, list} <- safe_find(html, "#content h1"),
         {:ok, name} <- safe_text(list)
      do
      name = name
             |> String.trim_leading(" Threadmarks for:")
             |> String.trim
      {:ok, name}
    else
      err -> {:error, 'name error', err}
    end
  end

  def name(html, :ff) do
    with {:ok, list} <- safe_find(html, "#profile_top b"),
         {:ok, name} <- Enum.fetch(list, 0),
         {:ok, name} <- safe_text(name)
      do
      {:ok, name}
    else
      err -> {:error, 'name error', err}
    end
  end

  def name(html, :ao3) do
    with {:ok, list} <- safe_find(html, ".title.heading"),
         {:ok, name} <- safe_text(list)
      do
      {
        :ok,
        name
        |> String.trim
      }
    else
      err -> {:error, 'name error', err}
    end
  end

  def chapter_count(html, :sb) do
    with {:ok, list} <- safe_find(html, "#content .threadmarkList .threadmarkListItem")
      do
      {:ok, length(list)}
    else
      _err -> {:ok, 1}
    end
  end

  def chapter_count(html, :ao3) do
    with {:ok, list} <- safe_find(html, "dd.chapters"),
         {:ok, text} <- safe_text(list),
         %{"chapter_count" => chapter_count} <- Regex.named_captures(~r/(?<chapter_count>\d+)\//, text),
         {chapter_count, ""} <- Integer.parse(chapter_count)
      do
      {:ok, chapter_count}
    else
      _err -> {:ok, 1}
    end
  end

  def chapter_count(html, :ff) do
    with {:ok, list} <- safe_find(html, ".xgray.xcontrast_txt"),
         {:ok, text} <- safe_text(list),
         %{"chapter_count" => chapter_count} <- Regex.named_captures(~r/Chapters: (?<chapter_count>\d+)/, text),
         {chapter_count, ""} <- Integer.parse(chapter_count)
      do
      {:ok, chapter_count}
    else
      _err -> {:ok, 1}
    end
  end

  def chapter_at_selector(:first_chapter, :sb), do: "#content .threadmarkList .threadmarkListItem:first-child"
  def chapter_at_selector(:last_chapter, :sb), do: "#content .threadmarkList .threadmarkListItem:last-child"
  def chapter_at_selector(:first_chapter, :ff), do: ".xgray.xcontrast_txt span[data-xutime] + span[data-xutime]"
  def chapter_at_selector(:last_chapter, :ff), do: ".xgray.xcontrast_txt span[data-xutime]"
  def chapter_at_selector(:first_chapter, :ao3), do: "dd.published"
  def chapter_at_selector(:last_chapter, :ao3), do: "dd.status"


  def chapter_at(html, selector, :sb) do
    with {:ok, list} <- safe_find(html, chapter_at_selector(selector, :sb)),
         {:ok, attributes} <- safe_attribute(list, "data-content-date"),
         {:ok, attribute} <- parse_text(hd(attributes)),
         {string_date, ""} <- Integer.parse(attribute),
         {:ok, datetime} <- DateTime.from_unix(string_date)
      do
      {:ok, datetime}
    else
      _err -> chapter_at(html, :last_chapter, :ff)
    end
  end

  def chapter_at(html, selector, :ff) do
    with {:ok, list} <- safe_find(html, chapter_at_selector(selector, :ff)),
         {:ok, attributes} <- safe_attribute(list, "data-xutime"),
         {:ok, attribute} <- parse_text(
           (attributes)
           |> Enum.at(0)
         ),
         {string_date, ""} <- Integer.parse(attribute),
         {:ok, datetime} <- DateTime.from_unix(string_date)
      do
      {:ok, datetime}
    else
      _err -> {:ok, nil}
    end
  end

  def chapter_at(html, selector, :ao3) do
    with {:ok, list} <- safe_find(html, chapter_at_selector(selector, :ao3)),
         {:ok, date} <- safe_text(list),
         {:ok, datetime} <- NaiveDateTime.from_iso8601(date <> " 00:00:00")
      do
      {:ok, datetime}
    else
      _err -> {:ok, nil}
    end
  end

  def word_count(html, :sb) do
    with {:ok, list} <- safe_find(html, ".sectionFooter"),
         {:ok, counts} <- safe_text(list),
         {:ok, list} <- parse_list(Regex.run(~r"\d+", counts)),
         {:ok, count} <- Enum.fetch(list, 0),
         {count, ""} <- Integer.parse(count)
      do
      {:ok, count * 1000}
    else
      err -> {:error, 'word_count error', err}
    end
  end

  def word_count(html, :ff) do
    with {:ok, list} <- safe_find(html, ".xgray.xcontrast_txt"),
         {:ok, text} <- safe_text(list),
         %{"word_count" => word_count} <- Regex.named_captures(~r/Words: (?<word_count>\d+)/, remove_commas(text)),
         {word_count, ""} <- Integer.parse(word_count)
      do
      {:ok, word_count}
    else
      err -> {:error, 'word_count error', err}
    end
  end

  def word_count(html, :ao3) do
    with {:ok, list} <- safe_find(html, "dd.words"),
         {:ok, text} <- safe_text(list),
         {word_count, ""} <- Integer.parse(text)
      do
      {:ok, word_count}
    else
      err -> {:error, 'word_count error', err}
    end
  end

  def description(html, :ff) do
    with {:ok, list} <- safe_find(html, "[style='margin-top:2px']"),
         {:ok, description} <- safe_text(list)
      do
      {:ok, description}
    else
      err -> {:error, 'description error', err}
    end
  end

  def description(html, :ao3) do
    with {:ok, list} <- safe_find(html, ".summary .userstuff"),
         {:ok, description} <- safe_text(list)
      do
      {:ok, description}
    else
      err -> {:error, 'description error', err}
    end
  end

  def description(html, :sb) do
    {:ok, nil}
  end

  def fandoms(html, :ff) do
    with {:ok, list} <- safe_find(html, "#pre_story_links a:last-child"),
         {:ok, fandom_names} <- safe_text(list)
      do
      fandoms = fandom_names
                |> String.trim(" Crossover")
                |> String.split(" + ")
                |> Enum.map(&find_fandom/1)
                |> Enum.reject(&is_nil/1)
                |> Enum.map(&Map.get(&1, :id))
      {:ok, fandoms}
    else
      err -> {:ok, []}
    end
  end

  def fandoms(html, :ao3) do
    {:ok, []}
  end

  def fandoms(html, :sb) do
    {:ok, []}
  end

  def find_fandom(fandom_name) do
    Repo.get_by(Fandom, name: fandom_name)
  end



  def host_type(:sb), do: {:ok, :sb}
  def host_type(:sv), do: {:ok, :sb}
  def host_type(:ff), do: {:ok, :ff}
  def host_type(:fp), do: {:ok, :ff}
  def host_type(:ao3), do: {:ok, :ao3}

  def thread_no_threadmarks(id, :sb), do: "https://forums.spacebattles.com/threads/" <> id
  def thread_no_threadmarks(id, :sv), do: "https://forums.sufficientvelocity.com/threads/" <> id
  def thread(id, :sb), do: "https://forums.spacebattles.com/threads/" <> id <> "/threadmarks"
  def thread(id, :sv), do: "https://forums.sufficientvelocity.com/threads/" <> id <> "/threadmarks"
  def thread(id, :ff), do: "https://www.fanfiction.net/s/" <> id
  def thread(id, :fp), do: "https://www.fictionpress.com/s/" <> id
  def thread(id, :ao3), do: "https://archiveofourown.org/works/" <> id

  def fanfic_changeset(id, host) do
    with {:ok, host_type} <- IO.inspect(host_type(host)),
         {:ok, html} <- IO.inspect(safe_http_get(thread(id, host))),
         {:ok, name} <- IO.inspect(name(html, host_type)),
         {:ok, chapter_count} <- IO.inspect(chapter_count(html, host_type)),
         {:ok, word_count} <- IO.inspect(word_count(html, host_type)),
         {:ok, last_chapter_at} <- IO.inspect(chapter_at(html, :last_chapter, host_type)),
         {:ok, first_chapter_at} <- IO.inspect(chapter_at(html, :first_chapter, host_type)),
         {:ok, author_name} <- IO.inspect(author_name(html, host_type)),
         {:ok, description} <- IO.inspect(description(html, host_type)),
         {:ok, fandoms} <- IO.inspect(fandoms(html, host_type))
      do

      fanfic = %{
        :author_name => author_name,
        :name => name,
        :fandoms => fandoms,
        :description => description,
        :chapter_count => chapter_count,
        :word_count => word_count,
      }

      last_chapter_at = last_chapter_at || first_chapter_at;


      fanfic = if last_chapter_at do
        Map.merge(
          fanfic,
          %{
            :last_chapter_at_year => last_chapter_at
                                     |> Map.get(:year),
            :last_chapter_at_month => last_chapter_at
                                      |> Map.get(:month),
            :last_chapter_at_day => last_chapter_at
                                    |> Map.get(:day),
            :last_chapter_at_hour => last_chapter_at
                                     |> Map.get(:hour)
          }
        )
      else
        fanfic
      end

      first_chapter_at = first_chapter_at || last_chapter_at;


      fanfic = if first_chapter_at do
        Map.merge(
          fanfic,
          %{
            :first_chapter_at_year => first_chapter_at
                                      |> Map.get(:year),
            :first_chapter_at_month => first_chapter_at
                                       |> Map.get(:month),
            :first_chapter_at_day => first_chapter_at
                                     |> Map.get(:day),
            :first_chapter_at_hour => first_chapter_at
                                      |> Map.get(:hour),
          }
        )
      else
        fanfic
      end


      {:ok, fanfic}


    end
  end
end




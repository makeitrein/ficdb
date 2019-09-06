defmodule Ficdb.CronCrawler do


  alias Ficdb.{Repo, Directory, FanficCrawler}
  alias Directory.{Fanfic}

  def check_for_updates() do

    fanfics = Fanfic |> Repo.all

    for fanfic <- fanfics do
      Process.sleep(5000)
      with {:ok, latest_fanfic_stats} <- latest_fanfic_stats(fanfic) do
        changeset = Fanfic.cron_changeset(fanfic, latest_fanfic_stats)
        Repo.update(changeset)
        else
        err -> IO.inspect({"Failed to update in cron job", fanfic, err})
      end
    end
  end


  def latest_fanfic_stats(fanfic) do
    {status, id, host} = cond do
      !!fanfic.ff_id -> {:ok, fanfic.ff_id, :ff}
      !!fanfic.fp_id -> {:ok, fanfic.fp_id, :fp}
      !!fanfic.sb_id -> {:ok, fanfic.sb_id, :sb}
      !!fanfic.sv_id -> {:ok, fanfic.sv_id, :sv}
      !!fanfic.ff_id -> {:ok, fanfic.ff_id, :ff}
      !!fanfic.ao3_id -> {:ok, fanfic.ao3_id, :ao3}
      true -> {:error, nil, nil}
    end


    with {:ok, id, host} <- {status, id, host},
         {:ok, host_type} <- FanficCrawler.host_type(host),
         {:ok, html} <-  FanficCrawler.safe_http_get(FanficCrawler.thread(Integer.to_string(id), host)),
         {:ok, chapter_count} <- FanficCrawler.chapter_count(html, host_type),
         {:ok, word_count} <- FanficCrawler.word_count(html, host_type),
         {:ok, last_chapter_at} <- FanficCrawler.chapter_at(html, :last_chapter, host_type)
      do
      {
        :ok,
        %{
          :chapter_count => chapter_count,
          :word_count => word_count,
          :last_chapter_at => last_chapter_at
        }
      }
    else
      err -> IO.inspect {:error, err}
    end

  end

end




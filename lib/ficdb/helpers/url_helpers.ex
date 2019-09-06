defmodule Ficdb.UrlHelpers do

  def sb_url(nil), do: ""
  def sb_url(%{sb_id: nil} = fanfic), do: nil
  def sb_url(%{sb_id: sb_id} = fanfic), do: "https://forums.spacebattles.com/threads/" <> Integer.to_string fanfic.sb_id

end
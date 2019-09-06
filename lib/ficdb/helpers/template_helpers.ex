defmodule Ficdb.TemplateHelpers do
  def user_count do
    :ets.info(Ficdb.PubSub.Local0)[:size]
  end
end
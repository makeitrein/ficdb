defmodule Ficdb.UserHelpers do

  def topic_owner?(%{id: id}, %{submitter_id: submitter_id}) do
    id == submitter_id
  end

  def topic_owner?(_, _), do: false

end
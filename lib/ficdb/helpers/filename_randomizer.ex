defmodule Ficdb.FilenameRandomizer do
  @moduledoc """
  Randomize uploaded file names in schema changesets before persisting them in the database -
  prevents file name collisions from happening
  """

  def put_random_filename(%{"image" => %Plug.Upload{filename: name} = image} = attrs) do
    image = %Plug.Upload{image | filename: random_filename(name)}
    %{attrs | "image" => image}
  end
  def put_random_filename(attrs), do: attrs

  defp random_filename(name) do
    (:crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)) <> Regex.replace(~r[^a-zA-Z0-9 -], name, "")
  end
end

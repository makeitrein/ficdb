defmodule Ficdb.ColorHelpers do

  def rating_color(rating) do
    case rating do
      1 -> "red"
      2 -> "orange"
      3 -> "purple"
      4 -> "blue"
      5 -> "green"
    end
    end

  def bookshelf_color(bookshelf_name) do
    case bookshelf_name do
      "dropped" -> "red"
      "want_to_read" -> "orange"
      "reading" -> "purple"
      "read" -> "blue"
      "waiting_for_updates" -> "green"
    end
  end


end
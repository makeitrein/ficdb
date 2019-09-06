defmodule FicdbWeb.FanficView do
  use FicdbWeb, :view

  def title("index.html", _assigns) do
    "Ficdb - All Fanfics"
  end

  def title("show.html", %{fanfic: fanfic} = assigns) do
    "Ficdb - #{fanfic.name}"
  end

  def title("edit.html", _assigns) do
    "Ficdb - Edit Fanfic"
  end

  def title(_, _assigns) do
    "Ficdb - Fanfics"
  end

end

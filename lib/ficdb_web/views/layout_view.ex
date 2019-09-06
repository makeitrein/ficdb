defmodule FicdbWeb.LayoutView do
  use FicdbWeb, :view

  def render_layout(layout, assigns, do: content) do
    render(layout, Map.put(assigns, :inner_layout, content))
  end

  def title(_, _assigns) do
    "Ficdb - Layout"
  end
end

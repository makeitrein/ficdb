defmodule Ficdb.NumberHelpers do

  def in_thousands(nil), do: "???"
  def in_thousands(num), do: num |> Kernel./(1000) |> Kernel.trunc |> Integer.to_string |> Kernel.<>("k")

end
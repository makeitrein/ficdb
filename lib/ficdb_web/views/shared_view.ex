defmodule FicdbWeb.SharedView do
  use FicdbWeb, :view

  def title(_, _assigns) do
    "Ficdb - Shared"
  end

  def current_approval_status(fanfic)
    do
    answer = cond do
      not is_nil(fanfic.rejector_id) ->  "rejected"
      not is_nil(fanfic.approver_id) -> "approved"
      is_nil(fanfic.rejector_id) && is_nil(fanfic.approver_id) ->  "unapproved"
      true ->  "unapproved"
    end
  end

  def current_approval_status_human(fanfic)
    do
    answer = cond do
      not is_nil(fanfic.rejector_id) ->  "Rejected"
      is_nil(fanfic.rejector_id) && is_nil(fanfic.approver_id) ->  "Unapproved"
      true ->  ""
    end
  end
end

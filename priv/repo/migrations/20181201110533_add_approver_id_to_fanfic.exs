defmodule Ficdb.Repo.Migrations.AddApproverIdToFanfic do
  use Ecto.Migration

  def change do
    alter table(:fanfics) do
      add :approver_id, references(:veil_users, on_delete: :nothing)
    end
  end
end

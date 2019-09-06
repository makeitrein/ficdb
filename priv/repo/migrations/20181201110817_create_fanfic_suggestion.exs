defmodule Ficdb.Repo.Migrations.CreateFanficSuggestion do
  use Ecto.Migration

  def change do
    create table(:fanfic_suggestion) do
      add :suggestion_id, references(:suggestions, on_delete: :nothing)
      add :fanfic_id, references(:fanfics, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:fanfic_suggestion, [:suggestion_id])
    create index(:fanfic_suggestion, [:fanfic_id])
    create index(:fanfic_suggestion, [:submitter_id])
    create index(:fanfic_suggestion, [:updater_id])
  end
end

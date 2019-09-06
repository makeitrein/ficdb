defmodule Ficdb.Repo.Migrations.CreateSuggestions do
  use Ecto.Migration

  def change do
    create table(:suggestions) do
      add :content, :string
      add :fanfic_id, references(:fanfics, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:suggestions, [:fanfic_id])
    create index(:suggestions, [:submitter_id])
    create index(:suggestions, [:updater_id])
  end
end

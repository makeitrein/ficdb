defmodule Ficdb.Repo.Migrations.CreatePrimaryRelationship do
  use Ecto.Migration

  def change do
    create table(:primary_relationship) do
      add :character_id, references(:characters, on_delete: :nothing)
      add :fanfic_id, references(:fanfics, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:primary_relationship, [:character_id])
    create index(:primary_relationship, [:fanfic_id])
    create index(:primary_relationship, [:submitter_id])
    create index(:primary_relationship, [:updater_id])
  end
end

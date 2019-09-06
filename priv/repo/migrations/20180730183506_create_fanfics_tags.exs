defmodule Ficdb.Repo.Migrations.CreateFanficsTags do
  use Ecto.Migration

  def change do
    create table(:fanfics_tags) do
      add :tag_id, references(:tags, on_delete: :nothing)
      add :fanfic_id, references(:fanfics, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:fanfics_tags, [:tag_id])
    create index(:fanfics_tags, [:fanfic_id])
    create index(:fanfics_tags, [:submitter_id])
    create index(:fanfics_tags, [:updater_id])
  end
end

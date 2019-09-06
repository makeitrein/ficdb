defmodule Ficdb.Repo.Migrations.CreateFanficsFandoms do
  use Ecto.Migration

  def change do
    create table(:fanfics_fandoms) do
      add :fandom_id, references(:fandoms, on_delete: :nothing)
      add :fanfic_id, references(:fanfics, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:fanfics_fandoms, [:fandom_id])
    create index(:fanfics_fandoms, [:fanfic_id])
    create index(:fanfics_fandoms, [:submitter_id])
    create index(:fanfics_fandoms, [:updater_id])
  end
end

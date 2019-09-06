defmodule Ficdb.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :description, :text
      add :fandom_id, references(:fandoms, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:tags, [:fandom_id])
    create index(:tags, [:submitter_id])
    create index(:tags, [:updater_id])
  end
end

defmodule Ficdb.Repo.Migrations.CreateChapters do
  use Ecto.Migration

  def change do
    create table(:chapters) do
      add :url, :string
      add :posted_at, :utc_datetime
      add :reactions, :integer
      add :fanfic_id, references(:fanfics, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:chapters, [:fanfic_id])
    create index(:chapters, [:submitter_id])
    create index(:chapters, [:updater_id])
  end
end

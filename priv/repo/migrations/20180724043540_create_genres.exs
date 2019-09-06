defmodule Ficdb.Repo.Migrations.CreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :name, :string
      add :description, :text
      add :image, :string
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:genres, [:name])
    create index(:genres, [:submitter_id])
    create index(:genres, [:updater_id])
  end
end

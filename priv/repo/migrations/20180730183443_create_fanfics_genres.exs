defmodule Ficdb.Repo.Migrations.CreateFanficsGenres do
  use Ecto.Migration

  def change do
    create table(:fanfics_genres) do
      add :fanfic_id, references(:fanfics, on_delete: :nothing)
      add :genre_id, references(:genres, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:fanfics_genres, [:fanfic_id])
    create index(:fanfics_genres, [:genre_id])
    create index(:fanfics_genres, [:submitter_id])
    create index(:fanfics_genres, [:updater_id])
  end
end

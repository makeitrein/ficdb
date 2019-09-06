defmodule Ficdb.Repo.Migrations.AddStuffToSuggestions do
  use Ecto.Migration

  def change do

    alter table(:suggestions) do
      modify :content, :text
    end

    create table(:suggestions_genres) do
      add :genre_id, references(:genres, on_delete: :nothing)
      add :suggestion_id, references(:suggestions, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:suggestions_genres, [:genre_id])
    create index(:suggestions_genres, [:suggestion_id])
    create index(:suggestions_genres, [:submitter_id])
    create index(:suggestions_genres, [:updater_id])
  end
  
  
  end

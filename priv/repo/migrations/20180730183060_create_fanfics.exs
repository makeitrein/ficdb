defmodule Ficdb.Repo.Migrations.CreateFanfics do
  use Ecto.Migration

  def change do
    create table(:fanfics) do
      add :name, :string
      add :description, :text
      add :word_count, :integer
      add :is_completed, :boolean, default: false, null: false
      add :is_one_shot, :boolean, default: false, null: false
      add :status, :integer
      add :maturity, :integer
      add :first_chapter_at, :utc_datetime
      add :last_chapter_at, :utc_datetime
      add :urls, {:array, :string}
      add :main_character_id, references(:characters, on_delete: :nothing)
      add :author_id, references(:authors, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:fanfics, [:main_character_id])
    create index(:fanfics, [:author_id])
    create index(:fanfics, [:submitter_id])
    create index(:fanfics, [:updater_id])
  end
end

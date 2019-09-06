defmodule Ficdb.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :description, :text
      add :image, :string
      add :name, :string
      add :fandom_id, references(:fandoms, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:characters, [:fandom_id])
    create index(:characters, [:submitter_id])
    create index(:characters, [:updater_id])
  end
end

defmodule Ficdb.Repo.Migrations.CreateFandoms do
  use Ecto.Migration

  def change do
    create table(:fandoms) do
      add :url, :string
      add :name, :string
      add :author, :string
      add :description, :text
      add :fandom_type, :integer
      add :thumbnail, :string
      add :image, :string
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:fandoms, [:name])
    create index(:fandoms, [:submitter_id])
    create index(:fandoms, [:updater_id])
  end
end

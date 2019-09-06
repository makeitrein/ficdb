defmodule Ficdb.Repo.Migrations.CreateBookshelves do
  use Ecto.Migration

  def change do
    create table(:bookshelves) do
      add :name, :string
      add :description, :text
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:bookshelves, [:name, :submitter_id], name: :no_duplicate_name)
    create index(:bookshelves, [:submitter_id])
    create index(:bookshelves, [:updater_id])
  end
end

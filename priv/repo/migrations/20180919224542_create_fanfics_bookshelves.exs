defmodule Ficdb.Repo.Migrations.CreateFanficsBookshelves do
  use Ecto.Migration

  def change do
    create table(:fanfics_bookshelves) do
      add :bookshelf_id, references(:bookshelves, on_delete: :nothing)
      add :fanfic_id, references(:fanfics, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:fanfics_bookshelves, [:bookshelf_id])
    create index(:fanfics_bookshelves, [:fanfic_id])
    create index(:fanfics_bookshelves, [:submitter_id])
    create index(:fanfics_bookshelves, [:updater_id])
  end
end

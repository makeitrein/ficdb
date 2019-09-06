defmodule Ficdb.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string
      add :urls, {:array, :string}
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:authors, [:submitter_id])
    create index(:authors, [:updater_id])
  end
end

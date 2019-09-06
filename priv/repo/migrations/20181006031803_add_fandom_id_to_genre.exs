defmodule Ficdb.Repo.Migrations.AddFandomIdToGenre do
  use Ecto.Migration

  def change do
    alter table(:genres) do
      add :fandom_id, references(:fandoms, on_delete: :nothing)

    end
  end
end

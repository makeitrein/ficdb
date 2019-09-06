defmodule Ficdb.Repo.Migrations.AddGenreCategoryToGenre do
  use Ecto.Migration

  def change do
    alter table(:genres) do
      add :genre_type, :integer
    end
  end
end

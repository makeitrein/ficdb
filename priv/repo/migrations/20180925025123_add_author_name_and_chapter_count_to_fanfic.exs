defmodule Ficdb.Repo.Migrations.AddAuthorNameAndChapterCountToFanfic do
  use Ecto.Migration

  def change do
    alter table(:fanfics) do
      add :author_name, :string
      add :url, :string
      add :chapter_count, :integer
      add :fp_id, :integer
    end

    create unique_index(:fanfics, [:fp_id])

  end
end

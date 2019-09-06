defmodule Ficdb.Repo.Migrations.AddHeadlineToReview do
  use Ecto.Migration

  def change do
    alter table(:reviews) do
      add :headline, :string
    end
  end
end

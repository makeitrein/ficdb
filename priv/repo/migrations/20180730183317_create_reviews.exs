defmodule Ficdb.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :content, :text
      add :rating, :integer
      add :fanfic_id, references(:fanfics, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:reviews, [:fanfic_id])
    create index(:reviews, [:submitter_id])
    create index(:reviews, [:updater_id])
  end
end

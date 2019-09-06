defmodule Ficdb.Repo.Migrations.AddUniqueConstraintToReviewForFanfic do
  use Ecto.Migration

  def change do
    create unique_index(:reviews, [:fanfic_id, :submitter_id], name: :unique_review_club)

  end


end

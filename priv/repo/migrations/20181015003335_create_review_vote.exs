defmodule Ficdb.Repo.Migrations.CreateReviewVote do
  use Ecto.Migration

  def change do
    create table(:review_vote) do
      add :review_id, references(:reviews, on_delete: :nothing)
      add :submitter_id, references(:veil_users, on_delete: :nothing)
      add :updater_id, references(:veil_users, on_delete: :nothing)

      timestamps()
    end

    create index(:review_vote, [:review_id])
    create index(:review_vote, [:submitter_id])
    create index(:review_vote, [:updater_id])

    create unique_index(:review_vote, [:review_id, :submitter_id], name: :unique_review_vote_club)

  end
end

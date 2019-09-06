defmodule Ficdb.Directory.ReviewVote do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query


  schema "review_vote" do
    belongs_to :review, Ficdb.Directory.Review
    field :updater_id, :id

    belongs_to :submitter, Ficdb.Veil.User

    timestamps()
  end

  @doc false
  def changeset(review_vote, attrs) do
    review_vote
    |> cast(attrs, [:review_id, :submitter_id])
    |> validate_required([:review_id])
  end
end

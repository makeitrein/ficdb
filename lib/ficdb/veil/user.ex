defmodule Ficdb.Veil.User do
  @moduledoc """
  Veil's User Schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ficdb.Veil.{Request, Session}
  alias Ficdb.FilenameRandomizer

  schema "veil_users" do
    field(:email, :string)
    field(:verified, :boolean, default: false)
    field :image, Ficdb.Image.Type
    field :username, :string
    field :role, Ficdb.RoleEnum, default: :user

    has_many(:requests, Request)
    has_many(:sessions, Session)
    has_many(:bookshelves, Ficdb.Directory.Bookshelf, foreign_key: :submitter_id)
    has_many(:submitted_fanfics, Ficdb.Directory.Fanfic, foreign_key: :submitter_id)
    has_many(:updated_fanfics, Ficdb.Directory.Fanfic, foreign_key: :submitter_id)

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    params = FilenameRandomizer.put_random_filename params
    model
    |> cast(params, [:email, :verified, :username, :image, :role])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> make_email_lowercase()
    |> unique_constraint(:email)
  end

  defp make_email_lowercase(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        put_change(changeset, :email, email |> String.downcase())

      _ ->
        changeset
    end
  end
end

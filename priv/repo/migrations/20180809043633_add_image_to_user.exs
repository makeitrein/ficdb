defmodule Ficdb.Repo.Migrations.AddImageToAuthor do
  use Ecto.Migration

  def change do
    alter table(:veil_users) do
      add :image, :string
      add :role, :integer
      add :username, :string
    end

    create unique_index(:veil_users, [:username])

  end
end

defmodule Ficdb.Repo.Migrations.AddSbIdEtcToFanficAndChapter do
  use Ecto.Migration
  
  def change do
    alter table(:chapters) do
      add :sb_id, :integer
      add :ao3_id, :integer
      add :ff_id, :integer
      add :sv_id, :integer
      add :ah_id, :integer
      add :qq_id, :integer
      add :tb_id, :integer
    end

    alter table(:fanfics) do
      add :sb_id, :integer
      add :ao3_id, :integer
      add :ff_id, :integer
      add :sv_id, :integer
      add :ah_id, :integer
      add :qq_id, :integer
      add :tb_id, :integer
    end

    alter table(:authors) do
      add :sb_id, :integer
      add :ao3_id, :integer
      add :ff_id, :integer
      add :sv_id, :integer
      add :ah_id, :integer
      add :qq_id, :integer
      add :tb_id, :integer
    end


    create unique_index(:chapters, [:sb_id])
    create unique_index(:chapters, [:ff_id])
    create unique_index(:chapters, [:ao3_id])
    create unique_index(:chapters, [:sv_id])
    create unique_index(:chapters, [:ah_id])
    create unique_index(:chapters, [:qq_id])
    create unique_index(:chapters, [:tb_id])
    
    create unique_index(:fanfics, [:sb_id])
    create unique_index(:fanfics, [:ff_id])
    create unique_index(:fanfics, [:ao3_id])
    create unique_index(:fanfics, [:sv_id])
    create unique_index(:fanfics, [:ah_id])
    create unique_index(:fanfics, [:qq_id])
    create unique_index(:fanfics, [:tb_id])

    create unique_index(:authors, [:sb_id])
    create unique_index(:authors, [:ff_id])
    create unique_index(:authors, [:ao3_id])
    create unique_index(:authors, [:sv_id])
    create unique_index(:authors, [:ah_id])
    create unique_index(:authors, [:qq_id])
    create unique_index(:authors, [:tb_id])
    
    
  end
end

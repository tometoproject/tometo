defmodule Aph.Repo.Migrations.CreateStatuses do
  use Ecto.Migration

  def change do
    create table(:statuses) do
      add :content, :text
      add :avatar_id, references(:avatars, on_delete: :nothing)
      add :related_status_id, references(:statuses, on_delete: :nothing)

      timestamps()
    end

    create index(:statuses, [:avatar_id])
    create index(:statuses, [:related_status_id])
  end
end

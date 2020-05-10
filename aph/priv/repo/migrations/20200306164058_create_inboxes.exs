defmodule Aph.Repo.Migrations.CreateInboxes do
  use Ecto.Migration

  def change do
    create table(:inboxes) do
      add :answered, :boolean
      add :user_id, references(:users, on_delete: :delete_all)
      add :question_id, references(:questions, on_delete: :delete_all)

      timestamps(type: :timestamptz)
    end

    create index(:inboxes, [:user_id])
  end
end

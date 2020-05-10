defmodule Aph.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :content, :text
      add :inbox_id, references(:inboxes, on_delete: :nothing)
      add :avatar_id, references(:avatars, on_delete: :nothing)

      timestamps(type: :timestamptz)
    end

    create index(:answers, [:avatar_id])
  end
end

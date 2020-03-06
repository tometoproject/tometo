defmodule Aph.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :content, :text
      add :question_id, references(:questions, on_delete: :delete_all)
      add :avatar_id, references(:avatars, on_delete: :nothing)

      timestamps()
    end

    create index(:answers, [:avatar_id])
  end
end

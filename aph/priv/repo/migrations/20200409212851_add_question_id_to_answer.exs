defmodule Aph.Repo.Migrations.AddQuestionIdToAnswer do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      add :question_id, references(:questions)
    end
  end
end

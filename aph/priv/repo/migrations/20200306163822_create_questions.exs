defmodule Aph.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :content, :text

      timestamps(type: :timestamptz)
    end
  end
end

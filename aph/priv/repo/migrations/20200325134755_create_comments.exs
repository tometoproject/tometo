defmodule Aph.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :answer_id, references(:answers, on_delete: :delete_all)
      add :avatar_id, references(:avatars, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:answer_id])
  end
end

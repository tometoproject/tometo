defmodule Aph.Repo.Migrations.CreateAvatars do
  use Ecto.Migration

  def change do
    create table(:avatars) do
      add :name, :text
      add :pitch, :integer
      add :speed, :float
      add :language, :text
      add :gender, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:avatars, [:user_id])
  end
end

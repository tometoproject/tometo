defmodule Aph.Repo.Migrations.ChangeAuthEntities do
  use Ecto.Migration

  def change do
    drop table("sessions")
    drop table("statuses")

    alter table("users") do
      add :confirmed_at, :timestamptz
    end

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(updated_at: false, type: :timestamptz)
    end

    create unique_index(:users_tokens, [:context, :token])
  end
end

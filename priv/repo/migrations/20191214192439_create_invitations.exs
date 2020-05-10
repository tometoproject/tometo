defmodule Aph.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :code, :text
      add :created_by, references(:users, on_delete: :nothing)
      add :used_by, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:invitations, [:created_by])
    create index(:invitations, [:used_by])
  end
end

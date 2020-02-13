defmodule Aph.Repo.Migrations.AddRolesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :admin, :boolean
      add :mod, :boolean
    end
  end
end

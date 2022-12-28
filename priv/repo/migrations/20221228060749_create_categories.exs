defmodule Eshopy.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :citext

      timestamps()
    end
  end
end

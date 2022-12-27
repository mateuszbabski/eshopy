defmodule Eshopy.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :citext

      timestamps()
    end
  end
end

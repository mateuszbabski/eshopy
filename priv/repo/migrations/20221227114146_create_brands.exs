defmodule Eshopy.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :citext, null: false

      timestamps()
    end

    create unique_index(:brands, [:name])
  end
end

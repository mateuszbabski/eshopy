defmodule Eshopy.Repo.Migrations.CreateShippings do
  use Ecto.Migration

  def change do
    create table(:shippings) do
      add :name, :string
      add :price, :decimal
      add :days, :integer

      timestamps()
    end
  end
end

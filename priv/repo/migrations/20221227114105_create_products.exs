defmodule Eshopy.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :brand_id, references(:brands, on_delete: :delete_all), null: false
      add :category_id, references(:categories, on_delete: :delete_all), null: false

      add :name, :string, null: false
      add :description, :string, null: false
      add :unit_price, :decimal, null: false
      add :sku, :integer, null: false

      timestamps()
    end

    create unique_index(:products, [:sku])
    create index(:products, [:brand_id, :category_id])
  end
end

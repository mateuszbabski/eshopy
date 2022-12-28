defmodule Eshopy.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :brand_id, references(:brands, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)

      add :name, :string
      add :description, :string
      add :unit_price, :decimal
      add :sku, :integer
      add :image_upload, :string

      timestamps()
    end

    create unique_index(:products, [:sku])
  end
end

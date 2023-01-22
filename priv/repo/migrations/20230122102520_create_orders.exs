defmodule Eshopy.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :total_price, :decimal

      add :shipping_id, references(:shippings, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:orders, [:user_id])
    create index(:orders, [:shipping_id])
  end
end

defmodule Eshopy.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  alias Eshopy.Orders.Order.StatusEnum

  def change do
    StatusEnum.create_type()

    create table(:orders) do
      add :total_price, :decimal
      add :status, StatusEnum.type(), null: false

      add :shipping_id, references(:shippings, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:orders, [:user_id])
    create index(:orders, [:shipping_id])
  end
end

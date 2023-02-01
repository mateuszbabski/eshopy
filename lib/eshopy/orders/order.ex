defmodule Eshopy.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum

  defenum(StatusEnum, :status, [
    :in_progress,
    :completed
  ])

  schema "orders" do
    field :total_price, :decimal
    field :status, StatusEnum, default: :in_progress

    belongs_to :shipping, Eshopy.Delivery.Shipping, foreign_key: :shipping_id
    belongs_to :user, Eshopy.Accounts.User, foreign_key: :user_id

    has_many :order_items, Eshopy.Orders.OrderItem, on_delete: :delete_all, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total_price, :status])
    |> validate_required([:total_price, :status])
    |> validate_number(:total_price, greater_than: 0)
  end

  def status_changeset(order, attrs) do
    order
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> case do
      %{changes: %{status: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :status, "Error with changing status")
    end
  end
end

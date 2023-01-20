defmodule Eshopy.Delivery.Shipping do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shippings" do
    field :name, :string
    field :price, :decimal
    field :days, :integer

    timestamps()
  end

  @doc false
  def changeset(shipping, attrs) do
    shipping
    |> cast(attrs, [:name, :price, :days])
    |> validate_required([:name])
    |> validate_days()
    |> validate_price()
  end

  defp validate_price(changeset) do
    changeset
    |> validate_required(:price, message: "Price has to be set and be greater than 0")
    |> validate_number(:price, greater_than: 0)
  end

  defp validate_days(changeset) do
    changeset
    |> validate_required(:days, message: "Delivery time has to be greater than 0")
    |> validate_number(:days, greater_than: 0)
  end
end

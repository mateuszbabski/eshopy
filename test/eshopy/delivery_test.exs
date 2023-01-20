defmodule Eshopy.DeliveryTest do
  use Eshopy.DataCase

  alias Eshopy.Delivery

  describe "shippings" do
    alias Eshopy.Delivery.Shipping

    import Eshopy.DeliveryFixtures

    @invalid_attrs %{name: nil, price: nil}

    test "list_shippings/0 returns all shippings" do
      shipping = shipping_fixture()
      assert Delivery.list_shippings() == [shipping]
    end

    test "get_shipping!/1 returns the shipping with given id" do
      shipping = shipping_fixture()
      assert Delivery.get_shipping!(shipping.id) == shipping
    end

    test "create_shipping/1 with valid data creates a shipping" do
      valid_attrs = %{name: "some name", price: "120.5"}

      assert {:ok, %Shipping{} = shipping} = Delivery.create_shipping(valid_attrs)
      assert shipping.name == "some name"
      assert shipping.price == Decimal.new("120.5")
    end

    test "create_shipping/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Delivery.create_shipping(@invalid_attrs)
    end

    test "update_shipping/2 with valid data updates the shipping" do
      shipping = shipping_fixture()
      update_attrs = %{name: "some updated name", price: "456.7"}

      assert {:ok, %Shipping{} = shipping} = Delivery.update_shipping(shipping, update_attrs)
      assert shipping.name == "some updated name"
      assert shipping.price == Decimal.new("456.7")
    end

    test "update_shipping/2 with invalid data returns error changeset" do
      shipping = shipping_fixture()
      assert {:error, %Ecto.Changeset{}} = Delivery.update_shipping(shipping, @invalid_attrs)
      assert shipping == Delivery.get_shipping!(shipping.id)
    end

    test "delete_shipping/1 deletes the shipping" do
      shipping = shipping_fixture()
      assert {:ok, %Shipping{}} = Delivery.delete_shipping(shipping)
      assert_raise Ecto.NoResultsError, fn -> Delivery.get_shipping!(shipping.id) end
    end

    test "change_shipping/1 returns a shipping changeset" do
      shipping = shipping_fixture()
      assert %Ecto.Changeset{} = Delivery.change_shipping(shipping)
    end
  end
end

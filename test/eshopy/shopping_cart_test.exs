defmodule Eshopy.ShoppingCartTest do
  use Eshopy.DataCase

  alias Eshopy.ShoppingCart

  describe "cart_items" do
    alias Eshopy.ShoppingCart.CartItem

    import Eshopy.ShoppingCartFixtures

    @invalid_attrs %{}

    test "list_cart_items/0 returns all cart_items" do
      cart_item = cart_item_fixture()
      assert ShoppingCart.list_cart_items() == [cart_item]
    end

    test "get_cart_item!/1 returns the cart_item with given id" do
      cart_item = cart_item_fixture()
      assert ShoppingCart.get_cart_item!(cart_item.id) == cart_item
    end

    test "create_cart_item/1 with valid data creates a cart_item" do
      valid_attrs = %{}

      assert {:ok, %CartItem{} = cart_item} = ShoppingCart.create_cart_item(valid_attrs)
    end

    test "create_cart_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.create_cart_item(@invalid_attrs)
    end

    test "update_cart_item/2 with valid data updates the cart_item" do
      cart_item = cart_item_fixture()
      update_attrs = %{}

      assert {:ok, %CartItem{} = cart_item} = ShoppingCart.update_cart_item(cart_item, update_attrs)
    end

    test "update_cart_item/2 with invalid data returns error changeset" do
      cart_item = cart_item_fixture()
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.update_cart_item(cart_item, @invalid_attrs)
      assert cart_item == ShoppingCart.get_cart_item!(cart_item.id)
    end

    test "delete_cart_item/1 deletes the cart_item" do
      cart_item = cart_item_fixture()
      assert {:ok, %CartItem{}} = ShoppingCart.delete_cart_item(cart_item)
      assert_raise Ecto.NoResultsError, fn -> ShoppingCart.get_cart_item!(cart_item.id) end
    end

    test "change_cart_item/1 returns a cart_item changeset" do
      cart_item = cart_item_fixture()
      assert %Ecto.Changeset{} = ShoppingCart.change_cart_item(cart_item)
    end
  end

  describe "carts" do
    alias Eshopy.ShoppingCart.Cart

    import Eshopy.ShoppingCartFixtures

    @invalid_attrs %{}

    test "list_carts/0 returns all carts" do
      cart = cart_fixture()
      assert ShoppingCart.list_carts() == [cart]
    end

    test "get_cart!/1 returns the cart with given id" do
      cart = cart_fixture()
      assert ShoppingCart.get_cart!(cart.id) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      valid_attrs = %{}

      assert {:ok, %Cart{} = cart} = ShoppingCart.create_cart(valid_attrs)
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.create_cart(@invalid_attrs)
    end

    test "update_cart/2 with valid data updates the cart" do
      cart = cart_fixture()
      update_attrs = %{}

      assert {:ok, %Cart{} = cart} = ShoppingCart.update_cart(cart, update_attrs)
    end

    test "update_cart/2 with invalid data returns error changeset" do
      cart = cart_fixture()
      assert {:error, %Ecto.Changeset{}} = ShoppingCart.update_cart(cart, @invalid_attrs)
      assert cart == ShoppingCart.get_cart!(cart.id)
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = ShoppingCart.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> ShoppingCart.get_cart!(cart.id) end
    end

    test "change_cart/1 returns a cart changeset" do
      cart = cart_fixture()
      assert %Ecto.Changeset{} = ShoppingCart.change_cart(cart)
    end
  end
end

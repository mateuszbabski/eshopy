defmodule EshopyWeb.ShippingLiveTest do
  use EshopyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Eshopy.DeliveryFixtures

  @create_attrs %{name: "some name", price: "120.5"}
  @update_attrs %{name: "some updated name", price: "456.7"}
  @invalid_attrs %{name: nil, price: nil}

  defp create_shipping(_) do
    shipping = shipping_fixture()
    %{shipping: shipping}
  end

  describe "Index" do
    setup [:create_shipping]

    test "lists all shippings", %{conn: conn, shipping: shipping} do
      {:ok, _index_live, html} = live(conn, Routes.shipping_index_path(conn, :index))

      assert html =~ "Listing Shippings"
      assert html =~ shipping.name
    end

    test "saves new shipping", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.shipping_index_path(conn, :index))

      assert index_live |> element("a", "New Shipping") |> render_click() =~
               "New Shipping"

      assert_patch(index_live, Routes.shipping_index_path(conn, :new))

      assert index_live
             |> form("#shipping-form", shipping: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#shipping-form", shipping: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shipping_index_path(conn, :index))

      assert html =~ "Shipping created successfully"
      assert html =~ "some name"
    end

    test "updates shipping in listing", %{conn: conn, shipping: shipping} do
      {:ok, index_live, _html} = live(conn, Routes.shipping_index_path(conn, :index))

      assert index_live |> element("#shipping-#{shipping.id} a", "Edit") |> render_click() =~
               "Edit Shipping"

      assert_patch(index_live, Routes.shipping_index_path(conn, :edit, shipping))

      assert index_live
             |> form("#shipping-form", shipping: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#shipping-form", shipping: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shipping_index_path(conn, :index))

      assert html =~ "Shipping updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes shipping in listing", %{conn: conn, shipping: shipping} do
      {:ok, index_live, _html} = live(conn, Routes.shipping_index_path(conn, :index))

      assert index_live |> element("#shipping-#{shipping.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#shipping-#{shipping.id}")
    end
  end

  describe "Show" do
    setup [:create_shipping]

    test "displays shipping", %{conn: conn, shipping: shipping} do
      {:ok, _show_live, html} = live(conn, Routes.shipping_show_path(conn, :show, shipping))

      assert html =~ "Show Shipping"
      assert html =~ shipping.name
    end

    test "updates shipping within modal", %{conn: conn, shipping: shipping} do
      {:ok, show_live, _html} = live(conn, Routes.shipping_show_path(conn, :show, shipping))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Shipping"

      assert_patch(show_live, Routes.shipping_show_path(conn, :edit, shipping))

      assert show_live
             |> form("#shipping-form", shipping: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#shipping-form", shipping: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.shipping_show_path(conn, :show, shipping))

      assert html =~ "Shipping updated successfully"
      assert html =~ "some updated name"
    end
  end
end

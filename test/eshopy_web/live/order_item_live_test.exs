defmodule EshopyWeb.Order_itemLiveTest do
  use EshopyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Eshopy.OrdersFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_order_item(_) do
    order_item = order_item_fixture()
    %{order_item: order_item}
  end

  describe "Index" do
    setup [:create_order_item]

    test "lists all order_items", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.order_item_index_path(conn, :index))

      assert html =~ "Listing Order items"
    end

    test "saves new order_item", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.order_item_index_path(conn, :index))

      assert index_live |> element("a", "New Order item") |> render_click() =~
               "New Order item"

      assert_patch(index_live, Routes.order_item_index_path(conn, :new))

      assert index_live
             |> form("#order_item-form", order_item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order_item-form", order_item: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_item_index_path(conn, :index))

      assert html =~ "Order item created successfully"
    end

    test "updates order_item in listing", %{conn: conn, order_item: order_item} do
      {:ok, index_live, _html} = live(conn, Routes.order_item_index_path(conn, :index))

      assert index_live |> element("#order_item-#{order_item.id} a", "Edit") |> render_click() =~
               "Edit Order item"

      assert_patch(index_live, Routes.order_item_index_path(conn, :edit, order_item))

      assert index_live
             |> form("#order_item-form", order_item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order_item-form", order_item: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_item_index_path(conn, :index))

      assert html =~ "Order item updated successfully"
    end

    test "deletes order_item in listing", %{conn: conn, order_item: order_item} do
      {:ok, index_live, _html} = live(conn, Routes.order_item_index_path(conn, :index))

      assert index_live |> element("#order_item-#{order_item.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#order_item-#{order_item.id}")
    end
  end

  describe "Show" do
    setup [:create_order_item]

    test "displays order_item", %{conn: conn, order_item: order_item} do
      {:ok, _show_live, html} = live(conn, Routes.order_item_show_path(conn, :show, order_item))

      assert html =~ "Show Order item"
    end

    test "updates order_item within modal", %{conn: conn, order_item: order_item} do
      {:ok, show_live, _html} = live(conn, Routes.order_item_show_path(conn, :show, order_item))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Order item"

      assert_patch(show_live, Routes.order_item_show_path(conn, :edit, order_item))

      assert show_live
             |> form("#order_item-form", order_item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#order_item-form", order_item: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_item_show_path(conn, :show, order_item))

      assert html =~ "Order item updated successfully"
    end
  end
end

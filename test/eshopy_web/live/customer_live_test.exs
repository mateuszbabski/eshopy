defmodule EshopyWeb.CustomerLiveTest do
  use EshopyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Eshopy.AccountsFixtures

  @create_attrs %{city: "some city", country: "some country", lastname: "some lastname", name: "some name", postal: "some postal", street: "some street", telephone_number: "some telephone_number"}
  @update_attrs %{city: "some updated city", country: "some updated country", lastname: "some updated lastname", name: "some updated name", postal: "some updated postal", street: "some updated street", telephone_number: "some updated telephone_number"}
  @invalid_attrs %{city: nil, country: nil, lastname: nil, name: nil, postal: nil, street: nil, telephone_number: nil}

  defp create_customer(_) do
    customer = customer_fixture()
    %{customer: customer}
  end

  describe "Index" do
    setup [:create_customer]

    test "lists all customers", %{conn: conn, customer: customer} do
      {:ok, _index_live, html} = live(conn, Routes.customer_index_path(conn, :index))

      assert html =~ "Listing Customers"
      assert html =~ customer.city
    end

    test "saves new customer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.customer_index_path(conn, :index))

      assert index_live |> element("a", "New Customer") |> render_click() =~
               "New Customer"

      assert_patch(index_live, Routes.customer_index_path(conn, :new))

      assert index_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#customer-form", customer: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_index_path(conn, :index))

      assert html =~ "Customer created successfully"
      assert html =~ "some city"
    end

    test "updates customer in listing", %{conn: conn, customer: customer} do
      {:ok, index_live, _html} = live(conn, Routes.customer_index_path(conn, :index))

      assert index_live |> element("#customer-#{customer.id} a", "Edit") |> render_click() =~
               "Edit Customer"

      assert_patch(index_live, Routes.customer_index_path(conn, :edit, customer))

      assert index_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#customer-form", customer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_index_path(conn, :index))

      assert html =~ "Customer updated successfully"
      assert html =~ "some updated city"
    end

    test "deletes customer in listing", %{conn: conn, customer: customer} do
      {:ok, index_live, _html} = live(conn, Routes.customer_index_path(conn, :index))

      assert index_live |> element("#customer-#{customer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#customer-#{customer.id}")
    end
  end

  describe "Show" do
    setup [:create_customer]

    test "displays customer", %{conn: conn, customer: customer} do
      {:ok, _show_live, html} = live(conn, Routes.customer_show_path(conn, :show, customer))

      assert html =~ "Show Customer"
      assert html =~ customer.city
    end

    test "updates customer within modal", %{conn: conn, customer: customer} do
      {:ok, show_live, _html} = live(conn, Routes.customer_show_path(conn, :show, customer))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Customer"

      assert_patch(show_live, Routes.customer_show_path(conn, :edit, customer))

      assert show_live
             |> form("#customer-form", customer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#customer-form", customer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.customer_show_path(conn, :show, customer))

      assert html =~ "Customer updated successfully"
      assert html =~ "some updated city"
    end
  end
end

defmodule EshopyWeb.BrandLiveTest do
  use EshopyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Eshopy.CatalogFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_brand(_) do
    brand = brand_fixture()
    %{brand: brand}
  end

  describe "Index" do
    setup [:create_brand]

    test "lists all brands", %{conn: conn, brand: brand} do
      {:ok, _index_live, html} = live(conn, Routes.brand_index_path(conn, :index))

      assert html =~ "Listing Brands"
      assert html =~ brand.name
    end

    test "saves new brand", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.brand_index_path(conn, :index))

      assert index_live |> element("a", "New Brand") |> render_click() =~
               "New Brand"

      assert_patch(index_live, Routes.brand_index_path(conn, :new))

      assert index_live
             |> form("#brand-form", brand: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#brand-form", brand: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.brand_index_path(conn, :index))

      assert html =~ "Brand created successfully"
      assert html =~ "some name"
    end

    test "updates brand in listing", %{conn: conn, brand: brand} do
      {:ok, index_live, _html} = live(conn, Routes.brand_index_path(conn, :index))

      assert index_live |> element("#brand-#{brand.id} a", "Edit") |> render_click() =~
               "Edit Brand"

      assert_patch(index_live, Routes.brand_index_path(conn, :edit, brand))

      assert index_live
             |> form("#brand-form", brand: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#brand-form", brand: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.brand_index_path(conn, :index))

      assert html =~ "Brand updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes brand in listing", %{conn: conn, brand: brand} do
      {:ok, index_live, _html} = live(conn, Routes.brand_index_path(conn, :index))

      assert index_live |> element("#brand-#{brand.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#brand-#{brand.id}")
    end
  end

  describe "Show" do
    setup [:create_brand]

    test "displays brand", %{conn: conn, brand: brand} do
      {:ok, _show_live, html} = live(conn, Routes.brand_show_path(conn, :show, brand))

      assert html =~ "Show Brand"
      assert html =~ brand.name
    end

    test "updates brand within modal", %{conn: conn, brand: brand} do
      {:ok, show_live, _html} = live(conn, Routes.brand_show_path(conn, :show, brand))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Brand"

      assert_patch(show_live, Routes.brand_show_path(conn, :edit, brand))

      assert show_live
             |> form("#brand-form", brand: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#brand-form", brand: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.brand_show_path(conn, :show, brand))

      assert html =~ "Brand updated successfully"
      assert html =~ "some updated name"
    end
  end
end

defmodule Eshopy.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eshopy.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Eshopy.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        city: "some city",
        country: "some country",
        lastname: "some lastname",
        name: "some name",
        postal: "some postal",
        street: "some street",
        telephone_number: "some telephone_number"
      })
      |> Eshopy.Accounts.create_customer()

    customer
  end
end

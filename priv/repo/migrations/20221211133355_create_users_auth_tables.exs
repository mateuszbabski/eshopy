defmodule Eshopy.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  alias Eshopy.Accounts.User.RolesEnum


  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""
    RolesEnum.create_type()

    create table(:users) do
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :role, RolesEnum.type(), null: false
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end

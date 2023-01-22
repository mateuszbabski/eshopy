defmodule Eshopy.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string, null: false
      add :lastname, :string, null: false
      add :country, :string, null: false
      add :city, :string, null: false
      add :street, :string, null: false
      add :postal, :string, null: false
      add :telephone_number, :string, null: false

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:customers, [:user_id])
  end
end

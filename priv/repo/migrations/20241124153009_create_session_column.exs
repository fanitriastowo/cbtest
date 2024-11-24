defmodule Cbtest.Repo.Migrations.CreateSessionColumn do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      add :session, :string, null: false
    end
  end
end

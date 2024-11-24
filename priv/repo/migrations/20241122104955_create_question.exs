defmodule Cbtest.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :question, :text
      add :options, {:array, {:map, :string}}
      add :correct_answer, {:map, :string}
      add :discussion, {:map, :string}

      timestamps(type: :utc_datetime)
    end
  end
end

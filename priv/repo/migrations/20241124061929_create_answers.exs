defmodule Cbtest.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :questions_id,
          references("questions",
            type: :binary_id,
            on_delete: :delete_all,
            on_update: :update_all,
            options: [null: false]
          )

      add :answer, :string
      add :point, :integer

      timestamps(type: :utc_datetime)
    end
  end
end

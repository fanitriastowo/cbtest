defmodule Cbtest.Question do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "question" do
    field :question, :string
    field :options, {:array, {:map, :string}}
    field :correct_answer, {:map, :string}
    field :discussion, {:map, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(questions, attrs) do
    questions
    |> cast(attrs, [:question, :options, :correct_answer, :discussion])
    |> validate_required([:question, :options, :correct_answer, :discussion])
  end
end

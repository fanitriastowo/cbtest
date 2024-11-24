defmodule Cbtest.Answers do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cbtest.Questions
  alias Cbtest.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "answers" do
    belongs_to(:questions, Questions)

    field :answer, :string
    field :point, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Answers{} = answers, attrs \\ {}) do
    answers
    |> cast(attrs, [:question_id, :answer, :point])
    |> validate_required([:question_id, :answer, :point])
  end

  def insert(attrs) do
    Questions.get_by(%{id: attrs.id})
    |> Ecto.build_assoc(:answers, %{answer: attrs.answer, point: attrs.point})
    |> Repo.insert!()
  end
end

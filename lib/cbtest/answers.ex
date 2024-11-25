defmodule Cbtest.Answers do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cbtest.Questions
  alias Cbtest.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "answers" do
    field :answer, :string
    field :point, :integer
    field :session, :string
    belongs_to(:questions, Questions)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Answers{} = answers, attrs \\ {}) do
    answers
    |> cast(attrs, [:question_id, :answer, :point])
    |> validate_required([:question_id, :answer, :point])
  end

  def insert(attrs) do
    Questions.get_by(attrs.id)
    |> Ecto.build_assoc(:answers, %{
      answer: attrs.answer,
      point: attrs.point,
      session: attrs.session_id
    })
    |> Repo.insert!(
      on_conflict: {:replace_all_except, [:questions_id, :session]},
      conflict_target: [:questions_id, :session]
    )
  end
end

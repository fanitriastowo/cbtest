defmodule Cbtest.Answers do
  use Ecto.Schema
  import Ecto.Query

  alias Cbtest.{Questions, Repo}
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

  def insert(attrs) do
    %Answers{
      questions_id: attrs.id,
      answer: attrs.answer,
      point: attrs.point,
      session: attrs.session_id
    }
    |> Repo.insert!(
      on_conflict: {:replace_all_except, [:questions_id, :session]},
      conflict_target: [:questions_id, :session]
    )
  end

  def get_all_by_session(session_id) do
    from(a in Answers,
      where: a.session == ^session_id,
      select: %{questions_id: a.questions_id, answer: a.answer}
    )
    |> Repo.all()
  end

  def delete_by_session(session_id) do
    from(a in Answers, where: a.session == ^session_id)
    |> Repo.delete_all()
  end
end

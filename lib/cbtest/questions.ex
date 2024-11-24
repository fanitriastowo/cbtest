defmodule Cbtest.Questions do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Cbtest.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "questions" do
    field :question, :string
    field :options, {:array, {:map, :string}}
    field :correct_answer, {:map, :string}
    field :discussion, {:map, :string}

    has_many :answers, Cbtest.Answers

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Questions{} = questions, attrs \\ {}) do
    questions
    |> cast(attrs, [:question, :options, :correct_answer, :discussion])
    |> validate_required([:question, :options, :correct_answer, :discussion])
  end

  def get_first() do
    Questions
    |> select(
      [q],
      %{id: q.id, question: q.question, options: q.options}
    )
    |> first()
    |> Repo.one()
  end

  def insert(attrs) do
    %Questions{} |> changeset(attrs) |> Repo.insert()
  end

  def get_by(%{id: id}) do
    Repo.get_by!(Questions, id: id)
  end
end

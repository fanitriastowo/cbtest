defmodule Cbtest.Questions do
  use Ecto.Schema

  import Ecto.{Changeset, Query}

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
    |> cast_assoc(:answers)
  end

  def get_first() do
    Questions
    |> select(
      [q],
      %{id: q.id, question: q.question, options: q.options}
    )
    |> first(desc: :inserted_at)
    |> Repo.one()
  end

  def insert(attrs) do
    %Questions{} |> changeset(attrs) |> Repo.insert!()
  end

  def get_by(id) do
    Repo.get_by!(Questions, id: id)
  end

  def count() do
    from(q in Questions, select: count(q.id))
    |> Repo.one()
  end

  def get_all() do
    Questions
    |> select(
      [q],
      %{id: q.id, question: q.question, options: q.options}
    )
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end
end

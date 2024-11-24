defmodule Cbtest.Repo.Migrations.AddUniqueToQuestionsIdAndSession do
  use Ecto.Migration

  def change do
    create(
      unique_index(
        :answers,
        [:questions_id, :session],
        name: :answers_unique_questions_id_and_session
      )
    )
  end
end

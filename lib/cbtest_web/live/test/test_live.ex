defmodule CbtestWeb.Live.Test.TestLive do
  use CbtestWeb, :live_view

  alias Cbtest.{Questions, Answers}

  @impl true
  def mount(_, %{"session_id" => session_id}, socket) do
    c = Questions.get_all()
    question = Enum.at(c, 0)
    answer = Answers.get_by_session(session_id, question.id)

    {:ok,
     socket
     |> assign(q: question)
     |> assign(c: c)
     |> assign(active_id: Enum.at(c, 0).id)
     |> assign(session_id: session_id)
     |> assign(your_answer: (answer && answer.answer) || nil)
     |> assign(form: to_form(%{"question" => nil, "answer" => nil}))}
  end

  @impl true
  def handle_event(
        "choose",
        %{
          "answer" => answer,
          "question" => question,
          "session_id" => session_id
        },
        socket
      ) do
    Answers.insert(%{answer: answer, id: question, point: 1, session_id: session_id})

    {:noreply, socket}
  end

  @impl true
  def handle_event("go_to", %{"value" => question_id}, socket) do
    q = Questions.get_by(question_id)
    answer = Answers.get_by_session(socket.assigns.session_id, question_id)

    {:noreply,
     socket
     |> assign(q: q)
     |> assign(your_answer: (answer && answer.answer) || nil)
     |> assign(active_id: question_id)}
  end
end

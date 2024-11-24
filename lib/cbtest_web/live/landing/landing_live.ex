defmodule CbtestWeb.Live.Landing.LandingLive do
  use CbtestWeb, :live_view

  alias Cbtest.Questions
  alias Cbtest.Answers

  @impl true
  def mount(_, %{"session_id" => session_id}, socket) do
    q = Questions.get_first()

    {:ok,
     socket
     |> assign(q: q)
     |> assign(session_id: session_id)
     |> assign(form: to_form(%{"question" => nil, "answer" => nil}))}
  end

  @impl true
  def handle_event(
        "change",
        %{
          "answer" => answer,
          "question" => question,
          "session_id" => session_id
        },
        socket
      ) do
    Answers.insert(%{answer: answer, id: question, point: 1, session_id: session_id})

    {:noreply,
     socket
     |> put_flash(:info, "Answer is saved #{question}: #{answer}")}
  end
end

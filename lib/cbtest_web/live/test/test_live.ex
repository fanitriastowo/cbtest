defmodule CbtestWeb.Live.Test.TestLive do
  use CbtestWeb, :live_view

  alias Cbtest.{Questions, Answers}

  @impl true
  def mount(_, %{"session_id" => session_id}, socket) do
    c = Questions.get_all()

    {:ok,
     socket
     |> assign(q: Enum.at(c, 0))
     |> assign(c: c)
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

    {:noreply, socket}
  end

  @impl true
  def handle_event("go_to", %{"value" => id}, socket) do
    q = Questions.get_by(id)

    {:noreply,
     socket
     |> assign(q: q)}
  end
end

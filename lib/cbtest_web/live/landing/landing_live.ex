defmodule CbtestWeb.Live.Landing.LandingLive do
  use CbtestWeb, :live_view

  alias Cbtest.Questions
  alias Cbtest.Answers

  @impl true
  def mount(_, _, socket) do
    q = Questions.get_first()

    {:ok,
     socket
     |> assign(q: q)
     |> assign(form: to_form(%{"question" => nil, "answer" => nil}))}
  end

  @impl true
  def handle_event("change", %{"answer" => answer, "question" => question}, socket) do
    Answers.insert(%{answer: answer, id: question, point: 1})

    {:noreply,
     socket
     |> put_flash(:info, "Answer is saved #{question}: #{answer}")}
  end
end

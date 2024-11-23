defmodule CbtestWeb.Live.Landing.LandingLive do
  use CbtestWeb, :live_view

  alias Cbtest.Question

  @impl true
  def mount(_, _, socket) do
    q = Question.get_first()

    {:ok,
     socket
     |> assign(q: q)
     |> assign(form: to_form(%{"question" => nil, "answer" => nil}))}
  end

  @impl true
  def handle_event("change", params, socket) do
    IO.inspect(params, label: "change event")
    {:noreply, socket}
  end
end

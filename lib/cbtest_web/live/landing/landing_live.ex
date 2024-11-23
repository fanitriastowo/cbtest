defmodule CbtestWeb.Live.Landing.LandingLive do
  use CbtestWeb, :live_view
  import Ecto.Query

  alias Cbtest.Question
  alias Cbtest.Repo

  @impl true
  def mount(_, _, socket) do
    list =
      Question |> select([q], %{id: q.id, question: q.question, options: q.options}) |> Repo.all()

    {:ok,
     socket
     |> assign(list: list)
     |> assign(form: to_form(%{"question" => nil, "answer" => nil}))}
  end

  @impl true
  def handle_event("change", params, socket) do
    IO.inspect(params, label: "change event")
    {:noreply, socket}
  end
end

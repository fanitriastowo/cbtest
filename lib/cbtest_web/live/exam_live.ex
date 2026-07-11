defmodule CbtestWeb.ExamLive do
  use CbtestWeb, :live_view

  import CbtestWeb.ExamComponents

  alias Cbtest.{Questions, Answers}

  @duration 20 * 60

  @impl true
  def mount(_, %{"session_id" => session_id}, socket) do
    timer_ref = start_timer(socket)

    questions = Questions.get_all()

    answers =
      session_id
      |> Answers.get_all_by_session()
      |> Map.new(fn a -> {a.questions_id, a.answer} end)

    {:ok,
     assign(socket,
       session_id: session_id,
       questions: questions,
       idx: 0,
       answers: answers,
       flagged: %{},
       timer_ref: timer_ref,
       duration: @duration,
       time_left: @duration,
       submitted: false,
       show_confirm: false
     ), layout: false}
  end

  @impl true
  def handle_event("select", %{"question" => question_id, "answer" => answer}, socket) do
    Answers.insert(%{
      answer: answer,
      id: question_id,
      point: 1,
      session_id: socket.assigns.session_id
    })

    {:noreply, assign(socket, answers: Map.put(socket.assigns.answers, question_id, answer))}
  end

  @impl true
  def handle_event("toggle_flag", _params, socket) do
    idx = socket.assigns.idx
    flagged = Map.update(socket.assigns.flagged, idx, true, &(not &1))
    {:noreply, assign(socket, flagged: flagged)}
  end

  @impl true
  def handle_event("go_to", %{"idx" => idx}, socket) do
    {:noreply, assign(socket, idx: String.to_integer(idx))}
  end

  @impl true
  def handle_event("prev", _params, socket) do
    {:noreply, assign(socket, idx: max(0, socket.assigns.idx - 1))}
  end

  @impl true
  def handle_event("next", _params, socket) do
    last = length(socket.assigns.questions) - 1
    {:noreply, assign(socket, idx: min(last, socket.assigns.idx + 1))}
  end

  @impl true
  def handle_event("ask_submit", _params, socket) do
    {:noreply, assign(socket, show_confirm: true)}
  end

  @impl true
  def handle_event("cancel_submit", _params, socket) do
    {:noreply, assign(socket, show_confirm: false)}
  end

  @impl true
  def handle_event("confirm_submit", _params, socket) do
    cancel_timer(socket.assigns.timer_ref)
    {:noreply, assign(socket, submitted: true, show_confirm: false, timer_ref: nil)}
  end

  @impl true
  def handle_event("retake", _params, socket) do
    Answers.delete_by_session(socket.assigns.session_id)
    cancel_timer(socket.assigns.timer_ref)
    timer_ref = start_timer(socket)

    {:noreply,
     assign(socket,
       idx: 0,
       answers: %{},
       flagged: %{},
       timer_ref: timer_ref,
       time_left: @duration,
       submitted: false,
       show_confirm: false
     )}
  end

  @impl true
  def handle_info(:tick, %{assigns: %{submitted: true}} = socket), do: {:noreply, socket}

  def handle_info(:tick, socket) do
    case socket.assigns.time_left do
      t when t <= 1 ->
        cancel_timer(socket.assigns.timer_ref)
        {:noreply, assign(socket, time_left: 0, submitted: true, timer_ref: nil)}

      t ->
        {:noreply, assign(socket, time_left: t - 1)}
    end
  end

  # --- timer helpers ---

  defp start_timer(socket) do
    if connected?(socket) do
      {:ok, ref} = :timer.send_interval(1000, self(), :tick)
      ref
    end
  end

  defp cancel_timer(nil), do: :ok
  defp cancel_timer(ref), do: :timer.cancel(ref)

  # --- helpers used by the template ---

  @doc "Correct-answer letter, normalized to uppercase, handling both stored shapes."
  def correct_letter(%{"answer" => letter}), do: String.upcase(letter)

  def correct_letter(correct_answer) when is_map(correct_answer) do
    correct_answer
    |> Map.keys()
    |> List.first("")
    |> String.replace(~r/[^A-Za-z0-9]/, "")
    |> String.upcase()
  end

  def correct_letter(_), do: ""

  @doc "Number of correctly-answered questions for the given answers map."
  def score(questions, answers) do
    Enum.count(questions, fn q ->
      given = answers[q.id]
      given && String.upcase(given) == correct_letter(q.correct_answer)
    end)
  end
end

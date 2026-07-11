defmodule CbtestWeb.ExamLiveTest do
  use CbtestWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Cbtest.Questions

  defp make_question(text, correct_letter) do
    Questions.insert(%{
      "question" => text,
      "options" => [
        %{"option" => "A", "answer" => "opt A"},
        %{"option" => "B", "answer" => "opt B"},
        %{"option" => "C", "answer" => "opt C"}
      ],
      "correct_answer" => %{correct_letter => "the right one"},
      "discussion" => %{"text" => "because", "url" => "http://x"}
    })
  end

  test "renders the CBT UI and computes score on submit", %{conn: conn} do
    q1 = make_question("First question", "B")
    q2 = make_question("Second question", "A")

    {:ok, view, _html} = live(conn, "/exam")
    html = render(view)

    assert html =~ "Emotional Intelligence Assessment"
    assert html =~ "Question Navigator"
    assert html =~ "Question 1 <span"
    assert html =~ "opt A"

    # answer q1 correctly (B), q2 incorrectly (B, correct is A) — by explicit id, order-independent
    render_click(view, "select", %{"question" => q1.id, "answer" => "B"})
    render_click(view, "select", %{"question" => q2.id, "answer" => "B"})

    # submit flow
    assert render_click(view, "ask_submit") =~ "Submit your test?"
    html = render_click(view, "confirm_submit")

    assert html =~ "Assessment Complete"
    # 1 of 2 correct = 50%
    assert html =~ "50"
    assert html =~ "1 of 2 answered correctly"
  end

  test "prev is disabled on first question, next enabled", %{conn: conn} do
    make_question("Only A", "A")
    make_question("Only B", "B")

    {:ok, view, _html} = live(conn, "/exam")

    assert has_element?(view, "button[phx-click=prev][disabled]")
    refute has_element?(view, "button[phx-click=next][disabled]")
  end
end

defmodule CalculatorWeb.MainLive do
  use Phoenix.LiveView

  @numbers ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  @operators ["+", "-", "x", "÷"]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, initial_socket(socket)}
  end

  @impl true
  def handle_event("button_click", %{"value" => "AC"}, socket) do
    {:noreply, initial_socket(socket)}
  end

  @impl true
  def handle_event("button_click", %{"value" => number}, socket) when number in @numbers do
    socket =
      if is_nil(socket.assigns.operator) do
        socket
        |> assign(:num1, socket.assigns.num1 <> number)
        |> assign(:display, socket.assigns.num1 <> number)
      else
        socket
        |> assign(:num2, socket.assigns.num2 <> number)
        |> assign(:display, socket.assigns.num2 <> number)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("button_click", %{"value" => op}, socket) when op in @operators do
    socket =
      if is_nil(socket.assigns.operator) do
        socket
      else
        calculate(socket)
      end

    {:noreply, assign(socket, :operator, op)}
  end

  @impl true
  def handle_event("button_click", %{"value" => "="}, socket) do
    {:noreply, calculate(socket)}
  end

  defp initial_socket(socket) do
    socket
    |> assign(:display, 0)
    |> assign(:num1, "")
    |> assign(:operator, nil)
    |> assign(:num2, "")
  end

  defp calculate(socket) when socket.assigns.num1 == "" or socket.assigns.num2 == "", do: socket
  defp calculate(socket) do
    result = operation(socket.assigns.num1, socket.assigns.num2, socket.assigns.operator)

    socket
    |> assign(:display, result)
    |> assign(:num1, result)
    |> assign(:num2, "")
    |> assign(:operator, nil)
  end

  @spec operation(String.t(), String.t(), String.t()) :: String.t()
  defp operation(num1, num2, op) do
    num1 = String.to_integer(num1)
    num2 = String.to_integer(num2)

    do_operation(num1, num2, op) |> Integer.to_string()
  end

  @spec do_operation(integer, integer, String.t()) :: integer
  defp do_operation(num1, num2, "+"), do: num1 + num2
  defp do_operation(num1, num2, "-"), do: num1 - num2
  defp do_operation(num1, num2, "x"), do: num1 * num2
  defp do_operation(num1, 0, "÷"), do: 0
  defp do_operation(num1, num2, "÷"), do: div(num1, num2)
end

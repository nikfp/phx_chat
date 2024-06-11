defmodule PhxChatWeb.ChatLive do
  use Phoenix.LiveView
  import PhxChatWeb.CoreComponents
  alias PhxChat.Messages.NewUser
  alias PhxChat.Messages
  alias PhxChat.Messages.Message

  def render(assigns) do
    ~H"""
    <div class="m-4">
      <%= if !@username do %>
        <.simple_form for={@username_form} phx-change="validate" phx-submit="save">
          <.input
            field={@username_form[:username]}
            label="Username"
            phx-debounce="blur"
            placeholder="Please enter a username for the session"
          />
          <:actions>
            <button class="p-3 bg-slate-800 border border-slate-800 rounded-xl text-slate-100">Join</button>
          </:actions>
        </.simple_form>
      <% else %>
        <.live_component
          id="messages"
          module={PhxChatWeb.ChatMessages}
          username={@username}
          message_form={@message_form}
          messages={@messages}
        >
        </.live_component>
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:messages, [])
     |> assign(:username, nil)
     |> assign_new_user()
     |> clear_username_form()}
  end

  defp assign_new_user(socket) do
    socket
    |> assign(:new_user, %NewUser{})
  end

  def clear_username_form(socket) do
    form =
      socket.assigns.new_user
      |> Messages.change_user()
      |> to_form()

    assign(socket, :username_form, form)
  end

  def assign_username_form(socket, changeset) do
    assign(socket, :username_form, to_form(changeset))
  end

  def handle_event(
        "validate",
        %{"new_user" => user_params},
        %{assigns: %{new_user: new_user}} = socket
      ) do
    changeset =
      new_user
      |> Messages.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_username_form(socket, changeset)}
  end

  def assign_new_message(socket) do
    %{assigns: %{username: username}} = socket

    socket
    |> assign(:new_message, %Message{username: username})
  end

  defp clear_message_form(socket) do
    form =
      socket.assigns.new_message
      |> Messages.change_message()
      |> to_form()

    assign(socket, :message_form, form)
  end

  def handle_event("save", %{"new_user" => %{"username" => username}}, socket) do
    {:noreply,
     socket
     |> assign(username: username)
     |> assign_new_message()
     |> clear_message_form()}
  end

  # defp assign_message_form(socket, changeset) do
  #   assign(socket, :message_form, to_form(changeset))
  # end

  def handle_event("show_socket", _params, socket) do
    {:noreply, socket |> IO.inspect()}
  end

  def handle_event(
        "message_sent",
        %{"message" => %{"body" => body}},
        %{assigns: %{username: username, messages: messages}} = socket
      ) do
    case Messages.create_message(%{username: username, body: body}) do
      {:ok, message} ->
        {:noreply,
         socket
         |> assign(:messages, messages ++ [message])}

      {:error, value} ->
        IO.inspect(value)
        {:noreply, socket}
    end
  end

  def handle_info({:load_messages, data}, socket) do
    {:noreply, socket |> assign(:messages, data.messages)}
  end
end

defmodule PhxChatWeb.ChatLive do
  use Phoenix.LiveView
  import PhxChatWeb.CoreComponents
  alias PhxChat.Messages.NewUser
  alias PhxChat.Messages

  def render(assigns) do
    ~H"""
    <%= if !@username do %>
      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:username]} label="Username" phx-debounce="blur" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
    <% else %>
      <.live_component
        id="messages"
        module={PhxChatWeb.ChatMessages}
        messages={@messages}
        username={@username}
      >
      </.live_component>
    <% end %>
    <button phx-click="show_socket">show socket</button>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:username, "name")
     |> assign(:messages, [])
     |> assign_new_user()
     |> clear_form()}
  end

  def clear_form(socket) do
    form =
      socket.assigns.new_user
      |> Messages.change_user()
      |> to_form()

    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
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

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"new_user" => %{"username" => username}}, socket) do
    {:noreply, socket |> assign(username: username)}
  end

  def handle_event("show_socket", _params, socket) do
    {:noreply, socket |> IO.inspect()}
  end

  def handle_event("message_sent", unsigned_params, socket) do
    IO.inspect(unsigned_params)
    {:noreply, socket}
  end

  def handle_info({:load_messages, data}, socket) do
    IO.inspect(data)
    {:noreply, socket |> assign(:messages, data.messages)} 
  end

  defp assign_new_user(socket) do
    socket
    |> assign(:new_user, %NewUser{})
  end
end

defmodule PhxChatWeb.ChatMessages do
  use Phoenix.LiveComponent
  alias PhxChat.Messages
  import PhxChatWeb.CoreComponents

  attr :username, :string, required: true
  # attr :messages, :list, required: true

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl">Got the rendering component done</h1>


      <%= for message <- @messages do %>
        <p><%= message.body %></p>
      <% end %>
      <.simple_form for={@message_form} phx-submit="message_sent">
        <.input field={@message_form[:body]} type="text" />
        <:actions>
          <button>Send</button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(socket) do
    messages = Messages.list_messages()
    send(self(), {:load_messages, %{messages: messages}})
    {:ok, socket}
  end
end

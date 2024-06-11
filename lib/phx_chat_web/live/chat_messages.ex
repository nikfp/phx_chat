defmodule PhxChatWeb.ChatMessages do
  use Phoenix.LiveComponent
  alias PhxChat.Messages
  import PhxChatWeb.CoreComponents

  attr :username, :string, required: true
  attr :messages, :list, required: true

  def render(assigns) do
    ~H"""
    <div>
      <%= for message <- @messages do %>
        <p>[ <%= message.username %> ] - <%= message.body %></p>
      <% end %>
      <.simple_form for={@message_form} phx-submit="message_sent">
        <.input field={@message_form[:body]} type="text" placeholder="Enter a message to send" />
        <:actions>
          <button class="p-4 bg-slate-800 border border-slate-800 rounded-xl text-slate-100">
            Send
          </button>
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

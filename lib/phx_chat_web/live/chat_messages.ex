defmodule PhxChatWeb.ChatMessages do
  use Phoenix.LiveComponent
  alias PhxChat.Messages

  attr :username, :string, required: true
  attr :messages, :list, required: true

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl">Got the rendering component done</h1>

      <.form let={f} phx-submit="message_sent">
        <.input for={@f}/>

        <:actions>
        <button>Send</button>

        </:actions>
      </.form>
    </div>
    """
  end

  def mount(socket) do
    messages = Messages.list_messages()
    send(self(), {:load_messages, %{messages: messages}})
    {:ok, socket}
  end
end

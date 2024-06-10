defmodule PhxChat.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxChat.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        body: "some body",
        username: "some username"
      })
      |> PhxChat.Messages.create_message()

    message
  end
end

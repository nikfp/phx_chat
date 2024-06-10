defmodule PhxChat.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :username, :string
    field :body, :string

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:username, :body])
    |> validate_required([:username, :body])
    |> validate_length(:username, min: 2, max: 20)
    |> validate_length(:body, min: 2, max: 250)
  end
end

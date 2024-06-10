defmodule PhxChat.Messages.NewUser do
  defstruct [:username]
  @types %{username: :string}

  import Ecto.Changeset

  def changeset(%__MODULE__{} = user, attrs) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:username])
    |> validate_length(:username,
      min: 2,
      max: 20,
      message: "User name must be between 2 and 20 characters"
    )
  end
end

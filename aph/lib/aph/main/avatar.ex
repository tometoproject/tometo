defmodule Aph.Main.Avatar do
  @moduledoc """
  The Avatar model.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Aph.Accounts.User
  alias Aph.Main.Status

  schema "avatars" do
    field :gender, :string
    field :language, :string
    field :name, :string
    field :pitch, :integer
    field :speed, :float
    belongs_to :user, User
    has_many :statuses, Status

    timestamps()
  end

  @doc false
  def changeset(avatar, attrs) do
    avatar
    |> cast(attrs, [:name, :pitch, :speed, :language, :gender, :user_id])
    |> validate_required([:name, :pitch, :speed, :language, :gender, :user_id])
    |> validate_number(:pitch, less_than_or_equal_to: 20, greater_than_or_equal_to: -20)
    |> validate_number(:speed, less_than_or_equal_to: 4.0, greater_than_or_equal_to: 0.25)
  end
end

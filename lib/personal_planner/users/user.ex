defmodule PersonalPlanner.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:name, :email],
    sortable: [:name, :email]
  }

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :admin, :boolean, default: false
    timestamps(type: :utc_datetime)

    field :password, :string, virtual: true
    field :password_confirm, :string, virtual: true
    field :activated, :boolean, default: false
    field :activated_at, :utc_datetime
  end

  @doc false

  @valid_email_regex ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  @required_fields [:name, :email, :password, :password_confirm]
  def changeset(user, attrs) do
    user
    |> cast(attrs,  @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @valid_email_regex)
    |> validate_length(:password, min: 6)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_confirmation(:password, message: "does not match password")
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        if password do
          put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
        else
          changeset
        end
        _ ->
          changeset
    end
  end
end

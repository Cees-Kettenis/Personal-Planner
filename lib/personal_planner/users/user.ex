defmodule PersonalPlanner.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:name, :email],
    sortable: [:name, :email, :inserted_at],
    default_limit: 10,
    default_order: %{
      order_by: [:inserted_at],
      order_directions: [:asc]
    }
  }

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :admin, :boolean, default: false
    timestamps(type: :utc_datetime)
    field :image_url, :string
    field :password, :string, virtual: true
    field :password_confirm, :string, virtual: true
    field :activated, :boolean, default: false
    field :activated_at, :utc_datetime
  end

  @doc false

  @valid_email_regex ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  @attrs_to_save_or_update [:name, :email, :password, :password_confirm, :admin, :image_url]

  def changeset(user, attrs) do
    user
    |> cast(attrs,  @attrs_to_save_or_update)
    |> validate_required([:name, :email, :password, :password_confirm])
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @valid_email_regex)
    |> validate_length(:password, min: 6)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_confirmation(:password, message: "does not match password")
    |> put_password_hash()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, @attrs_to_save_or_update)
    |> validate_required([:name, :email])
    |> validate_blank([:password, :password_confirm])
    |> validate_length(:name, max: 50)
    |> validate_length(:email, max: 255)
    |> validate_format(:email, @valid_email_regex)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "does not match password")
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def password_reset_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirm])
    |> validate_required([:password, :password_confirm])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "does not match password")
    |> put_password_hash()
  end

  defp validate_blank(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, changeset ->
      if get_change(changeset, field) == nil do
        changeset
      else
        validate_required(changeset, field)
      end
    end)
  end

  def token_changeset(user, attrs) do
    user |> cast(attrs , [
      :activated,
      :activated_at
    ])
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

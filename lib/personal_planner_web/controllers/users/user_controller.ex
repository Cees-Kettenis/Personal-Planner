defmodule PersonalPlannerWeb.UserController do
  use PersonalPlannerWeb, :controller

  alias PersonalPlanner.Accounts
  alias PersonalPlanner.Accounts.User

  alias StbImage

  plug :logged_in_user when action in [:index, :show]
  plug :is_user_admin when action in [:new, :delete]
  plug :is_user_updating_themselves_or_admin when action in [:edit, :update]

  def index(conn, params) do
    with {:ok, {users, meta}} <- Accounts.list_users(params) do
      render(conn, :index, meta: meta, users: users, page_title: "User Management")
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset, page_title: "Create User")
  end



  def create(conn, %{"user" => user_params}) do
    case handle_image_upload(user_params) do
      {:ok, user_params} ->
        case Accounts.create_user(user_params) do
          {:ok, user} ->
            activation_token = PersonalPlanner.Token.gen_activation_token(user)
            PersonalPlanner.SendEmail.account_activation_email(user, activation_token) |> PersonalPlanner.Mailer.deliver()

            conn
            |> put_flash(:info, "User created successfully.")
            |> redirect(to: ~p"/login")

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, :new, changeset: changeset)
          end

        {:error, reason} ->
          conn
          |> put_flash(:error, "Image upload failed: #{reason}")
          |> render("new.html", changeset: User.changeset(%User{}, user_params))
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user, page_title: "View user | " <> user.name)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, :edit, user: user, changeset: changeset, page_title: "Update User | "  <> user.name)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    #check if we are going to update he image if so we want to delete the original file first or we will never delete them.
    if Map.has_key?(user_params, "image_url") && String.length(user.image_url) > 0 do
      File.rm("priv/static" <> user.image_url)
    end

    case handle_image_upload(user_params) do
      {:ok, user_params} ->
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
      end
      {:error, reason} ->
        conn
        |> put_flash(:error, "Image upload failed: #{reason}")
        |> render("edit.html", user: user, changeset: User.changeset(user, user_params))
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end

  def signup(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :signup, changeset: changeset, page_title: "Sign up")
  end

  defp handle_image_upload(%{"image_url" => %Plug.Upload{} = upload} = params) do
    file_extension = Path.extname(upload.filename)
    new_filename = "#{Ecto.UUID.generate()}#{file_extension}"
    save_img_path = Path.join(["priv/static/images/uploads", new_filename])

    case StbImage.read_file(upload.path) do
      {:ok, image} ->
        # Resize the image to 100x100 pixels
        resized_image = StbImage.resize(image, 150, 150)
        case File.write(save_img_path, StbImage.to_binary(resized_image, :png)) do
              :ok ->
                {:ok, Map.put(params, "image_url", "/images/uploads/#{new_filename}")}
              {:error, reason} ->
                 {:error, reason}
        end

      {:error, _reason} ->
        {:error, "Failed to load or process the image"}
    end
  end

  defp handle_image_upload(params), do: {:ok, params}
end

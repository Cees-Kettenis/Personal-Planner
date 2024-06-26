defmodule PersonalPlanner.TaskService do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PersonalPlanner.Repo

  alias PersonalPlanner.Task

  def list_tasks(params) do
    query =
      from t in Task,
        where: is_nil(t.completed_at) or t.completed_at >= ^Timex.now(),
        preload: [:creator, :assigned_to]
    Flop.validate_and_run(query, params, for: Task)
  end

  def my_list_tasks(params, user_id) do
    query =
      from t in Task,
        where: (is_nil(t.completed_at) or t.completed_at >= ^Timex.now()) and t.assigned_to_id == ^user_id,
        preload: [:creator, :assigned_to]
    Flop.validate_and_run(query, params, for: Task)
  end

    @doc """
     ## Examples

    iex> get!(123)
    %User{}

    iex> get!(456)
    ** (Ecto.NoResultsError)

"""
def get!(id), do: Repo.get!(Task, id)

    @doc """
     ## Examples

    iex> get_by!(123)
    %User{}

    iex> get!(456)
    ** (Ecto.NoResultsError)

"""
def get_by!(args), do: Repo.get_by(Task, args)


    @doc """
  Creates a Task.

  ## Examples

      iex> create_task(Task, %{field: new_value})
      {:ok, %Task{}}

      iex> create_task(Task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Task.

  ## Examples

      iex> update_task(Task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(Task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delet_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end


    @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(user)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end

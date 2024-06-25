defmodule PersonalPlanner.Task do
  alias PersonalPlanner.Accounts.User

  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:number, :title, :sequence, :assigned_to_id],
    sortable: [:sequence],
    default_order: %{
      order_by: [:sequence],
      order_directions: [:asc]
    }
  }

  schema "tasks" do
    #required upon creation
    field :number, :string
    field :title, :string
    field :description, :string
    field :sequence, :integer # a number that orders the list of tasks to do in any listing page.
    field :task_type, :integer #0 is task, 1 is bug. in the future we can expand this. enum maybe?
    field :due_date, :date
    belongs_to :creator, User


    #optional upon creation
    belongs_to :assigned_to, User
    field :started_at, :utc_datetime, default: nil
    field :completed_at, :utc_datetime, default: nil
    field :week, :integer, default: nil #a week field to allow us to quickly index and filter by the week number we want to see.
    field :year, :integer, default: nil #a year field to allow us to quickly index and filter by the year number we want to see.
    field :parent_task_number, :string, default: nil
    field :root_task_number, :string, default: nil

    timestamps(type: :utc_datetime)
  end

  defp schema_fields do
    __schema__(:fields) -- [:id, :inserted_at, :updated_at]
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, schema_fields())
    |> validate_required([:number, :title, :description, :sequence, :task_type, :due_date])
  end
end

defmodule Backend.Tasks.SerialComment do
  @derive Jason.Encoder
  defstruct [:id, :task_id, :author, :content]
end

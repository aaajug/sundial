defmodule Backend.Boards.SerialBoard do
  @derive Jason.Encoder
  defstruct [:id, :title, :owner_id]
end

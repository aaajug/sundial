defmodule Sundial.API.ResponseHelper do
  alias Sundial.API.Errors

  def parse(response) do
    {
      {:error, get_error_messages(response["error"])},
      {:success_info, get_info(response)},
      {:data, response["data"]}
    }
  end

  defp get_info(%{"success_info" => success_info}), do: success_info
  defp get_info(%{} = _response_body), do: get_info
  defp get_info(), do: nil
  defp get_info(response_body), do: response_body

  defp get_error_messages(%{"errors" => errors}) do
    # "error" => %{
    #    "errors" => %{"email" => ["has already been taken"]},
    #   "message" => "Couldn't create user"
    # }
    errors
      |> Enum.map(
        fn {key, error} ->
          {key, String.capitalize(key) <> " " <> Enum.at(error, 0) <> "."}
        end
      )
      |> Map.new
  end

  defp get_error_messages(response_body) do
    cond do
      response_body == nil -> nil
      Map.has_key?(response_body, "message") -> response_body["message"]
      true -> nil
    end
  end
end

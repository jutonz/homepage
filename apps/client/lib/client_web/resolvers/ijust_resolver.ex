defmodule ClientWeb.IjustResolver do
  alias Client.Ijust

  def get_ijust_context(_parent, _args, %{context: context}) do
    with {:ok, user} <- Map.fetch(context, :current_user),
         {:ok, context} <- user |> Ijust.Context.get_for_user,
         do: {:ok, context},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to update password"}
           )
  end
end

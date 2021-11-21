defmodule Twitch.Util.Interactor do
  def perform(context, steps) do
    perform_steps(:up, context, [], steps)
  end

  defp perform_steps(direction, context, _performed_steps, []) do
    case direction do
      :up -> {:ok, context}
      :down -> {:error, context}
    end
  end

  defp perform_steps(direction, context, performed_steps, remaining_steps) do
    [next_step | later_steps] = remaining_steps

    case perform_step(direction, context, next_step) do
      {:ok, new_context} ->
        perform_steps(direction, new_context, [next_step | performed_steps], later_steps)

      {:error, new_context} ->
        perform_steps(:down, new_context, [], performed_steps)
    end
  end

  defp perform_step(direction, context, {module, args}) do
    # IO.puts("Calling #{inspect({module, direction, args})} with context #{inspect(context)}")
    apply(module, direction, [context, args])
  end
end

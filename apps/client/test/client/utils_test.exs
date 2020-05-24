defmodule Client.UtilTest do
  use Client.DataCase, async: true
  alias Client.Util

  describe ".errors_to_sentence/1" do
    test "converts errors to a sentence" do
      data = %{}
      types = [blah: :string]
      attrs = %{blah: "12"}
      changeset =
        {data, types}
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.cast(attrs, ~w[blah]a)
        |> Ecto.Changeset.validate_length(:blah, is: 3)

      errors = Util.errors_to_sentence(changeset)

      assert errors == %{blah: ["should be 3 character(s)"]}
    end

    test "returns an empty map if the changeset is valid" do
      data = %{}
      types = [blah: :string]
      attrs = %{blah: "123"}
      changeset =
        {data, types}
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.cast(attrs, ~w[blah]a)
        |> Ecto.Changeset.validate_length(:blah, is: 3)

      errors = Util.errors_to_sentence(changeset)

      assert errors == %{}
    end
  end
end

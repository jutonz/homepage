defmodule Client.UtilTest do
  use Client.DataCase, async: true
  alias Client.Util

  describe ".attribute_errors/1" do
    test "converts errors to a sentence" do
      data = %{}
      types = [blah: :string]
      attrs = %{blah: "12"}

      changeset =
        {data, types}
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.cast(attrs, ~w[blah]a)
        |> Ecto.Changeset.validate_length(:blah, is: 3)

      errors = Util.attribute_errors(changeset)

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

      errors = Util.attribute_errors(changeset)

      assert errors == %{}
    end
  end

  describe ".errors_to_sentence/1" do
    test "returns a sentence of errors for the changeset" do
      data = %{}
      types = [blah: :string]
      attrs = %{blah: "12"}

      changeset =
        {data, types}
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.cast(attrs, ~w[blah]a)
        |> Ecto.Changeset.validate_length(:blah, is: 3)

      errors = Util.errors_to_sentence(changeset)

      assert errors == "blah should be 3 character(s)"
    end
  end

  describe "format_number/1" do
    test "returns 3 unformatted" do
      assert Util.format_number(3) == "3"
    end

    test "returns 30 unformatted" do
      assert Util.format_number(30) == "30"
    end

    test "returns 300 unformatted" do
      assert Util.format_number(300) == "300"
    end

    test "returns 3000 as 3,000" do
      assert Util.format_number(3000) == "3,000"
    end

    test "returns 300000 as 300,000" do
      assert Util.format_number(300_000) == "300,000"
    end

    test "returns 3000000 as 3,000,000" do
      assert Util.format_number(3_000_000) == "3,000,000"
    end

    test "returns 3000000000 as 3,000,000,000" do
      assert Util.format_number(3_000_000_000) == "3,000,000,000"
    end

    test "formats a negative number" do
      assert Util.format_number(-1000) == "-1,000"
    end

    test "returns 3.0 as 3.0" do
      assert Util.format_number(3.0) == "3.0"
    end

    test "returns 3000.19 as 3,000.2" do
      assert Util.format_number(3000.19) == "3,000.2"
    end
  end
end

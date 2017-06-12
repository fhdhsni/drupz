Code.load_file("addends_finder.exs", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule AddendsTest do
  use ExUnit.Case

  test "should return -1" do
    assert Addends.find([1, 2, 3, 9], 8) == -1
  end

  test "sorted list" do
    assert Addends.find([1, 2, 4, 4], 8) == [{2, 3}]
  end

  test "unsorted list" do
    assert Addends.find([4, 2, 1, 4], 8) == [{0, 3}]
  end

  test "list includes negative numbers" do
    catch_error Addends.find([4, -12, 1, 4], 8)
  end

  test "list includes franction(non-interger number)" do
    catch_error Addends.find([4, 0.5, 1, 4], 8)
  end

  test "list includes string element" do
    catch_error Addends.find([4, "foo", 1, 4], 8)
  end

  test "raise if k is not interger" do
    catch_error Addends.find([4, 2, 1, 4], "foo")
  end

  # @tag :pending
  test "a huge list" do
    result =
      0..10_000_000
      |> Enum.into([])
      |> Addends.find(15)

    assert result == [{0, 15}, {1, 14}, {2, 13}, {3, 12}, {4, 11}, {5, 10}, {6, 9}, {7, 8}]
  end
end

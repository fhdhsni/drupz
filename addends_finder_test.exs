Code.load_file("addends_finder.exs", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule AddendsTest do
  use ExUnit.Case

  setup_all do
    ten_millions = 0..10_000_000 |> Enum.into([])
    {:ok, variable: ten_millions}
  end

  # @tag :pending
  test "should return -1" do
    assert Addends.find([1, 2, 3, 9], 8) == -1
  end

  # @tag :pending
  test "sorted list" do
    assert Addends.find([1, 2, 3, 5], 8) == [{2, 3}]
  end

  # @tag :pending
  test "unsorted list" do
    assert Addends.find([3, 2, 1, 5], 8) == [{0, 3}]
  end

  # @tag :pending
  test "list includes negative numbers" do
    catch_error Addends.find([4, -12, 1, 4], 8)
  end

  # @tag :pending
  test "list includes franction(non-interger number)" do
    catch_error Addends.find([4, 0.5, 1, 4], 8)
  end

  # @tag :pending
  test "list includes string element" do
    catch_error Addends.find([4, "foo", 1, 4], 8)
  end

  # @tag :pending
  test "raise if k is not interger" do
    catch_error Addends.find([4, 2, 1, 4], "foo")
  end

  # @tag :pending
  test "10 million items, assuming *unsorted*", %{variable: ten_millions} do
    assert Addends.find(ten_millions, 15) == [{0, 15}, {1, 14}, {2, 13}, {3, 12}, {4, 11}, {5, 10}, {6, 9}, {7, 8}]
  end

  # @tag :pending
  test "10 million items but guaranteed to be *sorted*", %{variable: ten_millions} do
    assert Addends.find(ten_millions, 15, :sorted) == [{0, 15}, {1, 14}, {2, 13}, {3, 12}, {4, 11}, {5, 10}, {6, 9}, {7, 8}]
  end

  # @tag :pending
  test "evil", %{variable: ten_millions} do
    # only for measuring speed
    # Currently it gets completed in 1.8s in my system. Before this commit it was more than 3s.
    # This commit slows the process in some situtions (but it's negligible) but it's beneficial when k is a large number.
    Addends.find(ten_millions, 10_000, :sorted) 
    assert true
  end

end

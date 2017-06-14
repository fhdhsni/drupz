Code.load_file("addends_finder.exs", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule AddendsTest do
  use ExUnit.Case

  def make_a_weird_list(i \\ 0, acc \\ [])
    def make_a_weird_list(i, acc) do
    cond do
      i == 10_000_000 -> acc
      true            -> make_a_weird_list(i + 1, [1 | acc])
    end
  end

  setup_all do
      ten_millions = 0..10_000_000 |> Enum.into([])
      ten_million_ones = make_a_weird_list()
      {:ok, variable: ten_millions, ones: ten_million_ones}
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
    assert Addends.find(ten_millions, 15) == [{7, 8}, {6, 9}, {5, 10}, {4, 11}, {3, 12}, {2, 13}, {1, 14}, {0, 15}]
  end

  # @tag :pending
  test "10 million items but guaranteed to be *sorted*", %{variable: ten_millions} do
    assert Addends.find(ten_millions, 15, :sorted) == [{7, 8}, {6, 9}, {5, 10}, {4, 11}, {3, 12}, {2, 13}, {1, 14}, {0, 15}]
  end

  # @tag :pending
  test "proof of dumbness", %{ones: ten_million_ones} do
    assert Addends.find(ten_million_ones, 9, :sorted) == -1
  end

end

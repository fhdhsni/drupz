Code.load_file("not_my_algorithm.exs", __DIR__)

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
      zero_to_ten_million = 0..10_000_000 |> Enum.into([])
      zero_to_one_million = 0..1_000_000 |> Enum.into([])
      ten_million_ones = make_a_weird_list()
      {:ok, to_ten: zero_to_ten_million, ones: ten_million_ones, to_one: zero_to_one_million}
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
  # test "list includes negative numbers" do
  #   catch_error Addends.find([4, -12, 1, 4], 8)
  # end

  # # @tag :pending
  # test "list includes franction(non-interger number)" do
  #   catch_error Addends.find([4, 0.5, 1, 4], 8)
  # end

  # # @tag :pending
  # test "list includes string element" do
  #   catch_error Addends.find([4, "foo", 1, 4], 8)
  # end

  # # @tag :pending
  # test "raise if k is not interger" do
  #   catch_error Addends.find([4, 2, 1, 4], "foo")
  # end

  # @tag :pending
  test "10 million items", %{to_ten: zero_to_ten_million} do
    assert Addends.find(zero_to_ten_million, 15) == [{0, 15}, {1, 14}, {2, 13}, {3, 12}, {4, 11}, {5, 10}, {6, 9}, {7, 8}]
  end

  # @tag :pending
  test "proof of dumbness", %{ones: ten_million_ones} do
    assert Addends.find(ten_million_ones, 9) == -1
  end

  test "wildly improved?", %{to_one: zero_to_one_million} do
    assert Addends.find(zero_to_one_million, 3_000_000_000) == -1
  end

end

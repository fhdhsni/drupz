defmodule Addends do
  @doc """
  Given n integers and a value K, it finds the indices of the pair of numbers such that the pair
  adds up to the given value K and return −1, −1 if no such pair exists.
  """
  @spec find([Interger], Interger) :: [Interger] | -1
  def find(_list, k) when is_integer(k) == false do
      raise ArgumentError, message: "The second argument should be an integer"
  end
  def find(list, k) do
    list
    |> Enum.with_index
    # Since all the intergers are positive, omitting those that are > k saves us some unnecessary computation
    |> Enum.filter(&do_filter(&1, k))
    |> do_find(k)
    |> Enum.reverse
    |> (fn [] -> -1; result -> result end).()
  end

  defp do_find(list, k, acc \\ [])
  defp do_find([], _k, acc), do: acc
  defp do_find([head | tail], k, acc) do
    acc = tail |> Enum.reduce(acc, &do_reduce(&1, &2, k, head))

    do_find(tail, k, acc)
  end

  defp do_filter({value, _index}, k) do
      cond do
        !is_integer(value) -> raise ArgumentError, message: "The list should only comprise numbers"
        value < 0 -> raise ArgumentError, message: "Nah! the given list should not have any negative integer"
        value < 1 and value > 0 -> raise ArgumentError, message: "Nah! Only whole numbers are allowd in the list"
        value > k -> false
        true -> true
      end
  end

  defp do_reduce(current, accumulator, k, head) do
    {value_of_current, index_of_current} = current
    {value_of_head, index_of_head} = head

    sum = value_of_current + value_of_head
    cond do
      sum == k -> [{index_of_head, index_of_current} | accumulator]
      true     -> accumulator
    end
  end
end

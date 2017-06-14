defmodule Addends do
  @doc """
  Given n integers and a value K, it finds the indices of the pair of numbers such that the pair
  adds up to the given value K and return −1, −1 if no such pair exists.
  """
  @spec find([Interger], Interger) :: [Interger] | -1
  def find(list, k, status \\ :unsort)

  def find(_list, k, _status) when is_integer(k) == false do
    raise ArgumentError, message: "The second argument should be an integer"
  end

  def find(list, k, :sorted) do
    list
    |> Enum.reduce_while({0, []}, &index_and_filter_sorted(&1, &2, k))
    |> (fn {_index, list} -> list end).()
    |> Enum.reverse
    |> do_find(k)
    |> (fn [] -> -1; result -> result end).()
  end

  def find(list, k, :unsort) do
    list
    |> Enum.reduce({0, []}, &index_and_filter(&1, &2, k))
    |> (fn {_total_number_of_elements_in_original_list, list} -> list end).()
    |> Enum.sort_by(fn {item, _index} -> item end) # sort the list, it's costly but we benifit furthre down the road.
    |> do_find(k)
    |> (fn [] -> -1; result -> result end).()
  end

  defp do_find(list, k, acc \\ [])
  defp do_find([], _k, acc), do: acc |> Enum.reverse
  defp do_find([head | tail], k, acc) do
    {value_of_head, index_of_head} = head
    cond do
      value_of_head > k ->  Enum.reverse(acc) # There's no point in continuing if first number is bigger than k

      true              ->
        acc = tail |> Enum.reduce(acc, &do_reduce(&1, &2, k, head))
        do_find(tail, k, acc)
    end
  end

  defp do_reduce(current, accumulator, k, head) do
    {value_of_current, index_of_current} = current
    {value_of_head, index_of_head} = head

    sum = value_of_current + value_of_head
    cond do
      # value_of_head > k -> {:halt, accumulator}
      sum == k          -> [{index_of_head, index_of_current} | accumulator]
      true              -> accumulator
    end
  end

  defp index_and_filter(x, {index, acc}, k) do
    error_maybe?(x)
    cond do
      # since we don't have negative numbers and x being bigger than k, in this case we know x not gonna be an answer.
      x > k -> {index + 1, acc} # omitting x
      true  -> {index + 1, [{x, index} | acc]}
    end
  end

  defp index_and_filter_sorted(x, {index, acc}, k) do
    error_maybe?(x)
    cond do
      # since our list is sorted we don't need to continue
      x > k -> {:halt, {index + 1, acc}} # omit x and get out of Enum.reduce_while
      true  -> {:cont, {index + 1, [{x, index} | acc]}}
    end
  end

  defp error_maybe?(x) do
    cond do
      !is_integer(x)    -> raise ArgumentError, message: "The list should only comprise numbers"
      x < 0             -> raise ArgumentError, message: "Nah! the given list should not have any negative integer"
      x < 1 and x > 0   -> raise ArgumentError, message: "Nah! Only whole numbers are allowd in the list"
      true              -> "we are good :)"
    end
  end
end

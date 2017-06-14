defmodule Helpers do
  def do_find(list, k, acc \\ [], memory \\ %{})
  def do_find([], _k,  acc, _memory), do: acc
  def do_find([head | tail], k, acc, memory) do
    {value_of_head, index_of_head} = head
    in_memory_for_current_head = Map.get(memory, value_of_head)

    cond do
      value_of_head > k                       ->
        Enum.reverse(acc) # Since the list is sorted, there's no point in continuing if first number is bigger than k

      in_memory_for_current_head == false     -> # So we've done this before and there had not been any result.
          do_find(tail, k, acc, memory)

      in_memory_for_current_head != nil       -> # We've done this before and there had been some result. We can use them.
        remember(in_memory_for_current_head, index_of_head)
        |> Enum.concat(acc)
        |> (fn acc -> do_find(tail, k, acc, memory) end).()

      true                                    -> # It's a brand new number, do the horse work.
        result = tail |> Enum.reduce([], &do_reduce(&1, &2, k, head))
        memory = do_save(memory, result, value_of_head)
        acc = Enum.concat(result, acc)
        do_find(tail, k, acc, memory)
    end
  end

  defp do_reduce(current, accumulator, k, head) do
    {value_of_current, index_of_current} = current
    {value_of_head, index_of_head} = head

    sum = value_of_current + value_of_head
    cond do
      sum == k          -> [{index_of_head, index_of_current} | accumulator]
      true              -> accumulator
    end
  end

  defp do_save(memory, result, value_of_head) do
    cond do
      result == [] -> Map.update(memory, value_of_head, false, fn _current_value -> false end)
      true         -> Map.update(memory, value_of_head, result, fn _current_value -> result end)
    end
  end

  defp remember(in_memory_for_current_head, index_of_head) do
    do_filter = fn {addend1_used_to_be_index_head, _addend2} ->
      cond do
        addend1_used_to_be_index_head < index_of_head -> false
        true                                          -> true
      end
    end

    do_map = fn {_addend1_used_to_be_index_head, addend2} ->
      {index_of_head, addend2}
    end

    in_memory_for_current_head
    |> Enum.filter_map(do_filter, do_map)
  end
end

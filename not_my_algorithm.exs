defmodule Addends do
  def find(list, k) do
    {_index, hash} = list |> Enum.reduce({0, %{}}, &do_reduce(&1, &2, k))

    do_find(list, hash, k)
    |> Enum.uniq
    |> (fn [] -> -1; result -> result end).()
  end

  defp do_reduce(item, {current_index, hash}, k) do
    cond do
      item > k -> {current_index + 1, hash} # skip the item

      true     ->
        hash = Map.put(hash, item, current_index)
        
        {current_index + 1, hash}    
    end
  end

  defp do_find(list, hash, k, result \\ []) do

    reduce = fn item, {i, accumulator} ->
      found = Map.get(hash, k - item)
      cond do
        found != nil and found != i ->
          pair = if i > found, do: {found, i}, else: {i, found}
          {i + 1, [pair | accumulator]}

        true                        -> {i + 1, accumulator}
      end
    end

    {_, result} = list |> Enum.reduce({0, result}, reduce)

    result
  end
end

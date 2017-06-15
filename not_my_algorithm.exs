defmodule Addends do
  def find(list, k) do
    {_index, map} = list |> Enum.reduce({0, %{}}, &do_reduce(&1, &2, k))

    do_find(list, map, k)
    |> Enum.uniq
    |> (fn [] -> -1; result -> result end).()
  end

  defp do_reduce(item, {current_index, map}, k) do
    cond do
      item > k -> {current_index + 1, map} # skip the item

      true     ->
        map = Map.put(map, item, current_index)
        
        {current_index + 1, map}    
    end
  end

  defp do_find(list, map, k, result \\ []) do

    reduce = fn item, {i, accumulator} ->
      found = Map.get(map, k - item)
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

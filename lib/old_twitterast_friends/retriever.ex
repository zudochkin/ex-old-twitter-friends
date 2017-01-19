defmodule OldTwitterastFriends.Retriever do
  def csv(screen_name \\ "vredniy") do
    screen_name |>
      get_all_friend_ids |>
      get_timeline |>
      sort_timeline |> CSV.encode |> Enum.join
  end

  defp get_last_tweet(id) do
    timeline = ExTwitter.user_timeline([id: id, count: 1])

    if length(timeline) == 0 do
      ["Sat Dec 31 16:44:49 +0000 1990", ExTwitter.user(id).screen_name]
    else
      [%{
          created_at: created_at,
          user: %{screen_name: screen_name}
       } | _] = timeline

      [created_at, screen_name]
    end
  end

  defp get_all_friend_ids(screen_name) do
    friend_ids(screen_name)
    # ExTwitter.friend_ids(screen_name, count: 10).items
  end

  defp get_timeline(friend_ids) do
    get_timeline(friend_ids, [])
  end

  defp get_timeline([], acc) do
    acc
  end

  defp get_timeline([friend_id | friend_ids], acc) do
    try do
      get_timeline(friend_ids, [get_last_tweet(friend_id) | acc])
    rescue
      ExTwitter.ConnectionError ->
        :timer.sleep(2)
      get_timeline([friend_id | friend_ids], acc)
    end
  end

  defp format_date(date_string) do
    Timex.parse! date_string, "%a %b %d %H:%M:%S %z %Y", :strftime
  end

  defp sort_timeline(timeline) do
    Enum.sort(timeline, fn a, b ->
      Timex.compare(format_date(Enum.at(b, 0)), format_date(Enum.at(a, 0))) >= 0
    end)
  end

  defp friend_ids(screen_name, acc \\ [], cursor \\ -1) do
    cursor = fetch_next(screen_name, cursor)
    if Enum.count(cursor.items) == 0 do
      List.flatten(acc)
    else
      friend_ids(screen_name, [cursor.items | acc], cursor.next_cursor)
    end
  end

  defp fetch_next(screen_name, cursor) do
    try do
      ExTwitter.friend_ids(screen_name, cursor: cursor)
    rescue
      e in ExTwitter.RateLimitExceededError ->
        :timer.sleep ((e.reset_in + 1) * 1000)
      fetch_next(screen_name, cursor)
    end
  end
end

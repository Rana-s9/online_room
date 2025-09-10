module StateCalendarsHelper
  def mental_key(emoji)
    {
      "🥳" => "amazing",
      "😊" => "good",
      "😐" => "bit_off",
      "😭" => "down",
      "😣" => "mental_sos"
    }[emoji] || "unknown"
  end

  def physical_key(emoji)
    {
      "💃" => "energetic",
      "🚶‍♀️" => "fine",
      "🧍‍♀️" => "sluggish",
      "🛌" => "awful",
      "🤒" => "physical_sos"
    }[emoji] || "unknown"
  end
end

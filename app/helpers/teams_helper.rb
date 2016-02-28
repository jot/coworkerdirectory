module TeamsHelper

  def relative_size(channels, channel)
    scale = 72.to_f / channels.pluck(:num_members).max
    (channel.num_members * scale) + 12
  end

end

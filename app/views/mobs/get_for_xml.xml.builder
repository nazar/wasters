xml.instruct!
xml.complete do
  @mobs.each do |item|
    xml.option(item.title, :value => item.id)
  end
end
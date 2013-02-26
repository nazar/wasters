xml.instruct!
xml.complete do
  @items.each do |item|
    xml.option(item.title, :value => item.id)
  end
end
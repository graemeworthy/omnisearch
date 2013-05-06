require 'ostruct'

class LocationIndex
  include OmniSearch::Indexes::Register
  indexes :location

  def collection
    [
      OpenStruct.new({id: 'paris_france',  name: "Paris",  label: "The city known as 'Paris'" }),
      OpenStruct.new({id: 'moscow_russia', name: "Moscow", label: "Moscow, capital of Russia" })
    ]
  end

  def record_template(item)
    {:id => item.id, :value => item.name, :label => item.label}
  end

end
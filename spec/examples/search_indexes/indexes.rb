# Encoding: UTF-8
class Physician
end
class Service
end
class Location
end
class PhysicianIndex
  include OmniSearch::Indexes::Register
  indexes :physician
  def collection
    []
  end
end

class LocationIndex
  include OmniSearch::Indexes::Register
  indexes :location
  def collection
    []
  end
end

class ServiceIndex
  include OmniSearch::Indexes::Register
  indexes :service
  def collection
    []
  end
end

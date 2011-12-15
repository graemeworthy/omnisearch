class Physician
end
class Service
end
class Location
end
class PhysicianIndex
  include OmniSearch::Indexes::Register
  indexes :physician
end

class LocationIndex
  include OmniSearch::Indexes::Register
  indexes :location
end

class ServiceIndex
  include OmniSearch::Indexes::Register
  indexes :service
end

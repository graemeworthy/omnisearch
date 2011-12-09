class Physician
end
class Service
end
class Location
end
class PhysicianIndex
  include OmniSearch::Indexes::Builder::Plaintext
  indexes :physician
end

class LocationIndex
  include OmniSearch::Indexes::Builder::Plaintext
  indexes :location
end

class ServiceIndex
  include OmniSearch::Indexes::Builder::Plaintext
  indexes :service
end

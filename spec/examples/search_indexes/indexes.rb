class PhysicianIndex
  include OmniSearch::Indexes::Builder::Plaintext
  def index_name
      'physician'
  end
end

class LocationIndex
  include OmniSearch::Indexes::Builder::Plaintext
  def index_name
      'location'
  end
end

class ServiceIndex
  include OmniSearch::Indexes::Builder::Plaintext
  def index_name
      'service'
  end
end

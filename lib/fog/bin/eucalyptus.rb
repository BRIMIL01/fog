class Eucalyptus < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Eucalyptus
      when :iam
        Fog::Eucalyptus::IAM
      when :eu_storage, :storage
        Fog::Storage::Eucalyptus
      else
        # @todo Replace most instances of ArgumentError with NotImplementedError
        # @todo For a list of widely supported Exceptions, see:
        # => http://www.zenspider.com/Languages/Ruby/QuickRef.html#35
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Eucalyptus[:compute] is not recommended, use Compute[:eucalpytus] for portability")
          Fog::Compute.new(:provider => 'Eucalyptus')
        when :iam
          Fog::Eucalyptus::IAM.new
        when :eu_storage
          Fog::Storage.new(:provider => 'Eucalyptus', :region => 'eucalyptus')
        when :storage
          Fog::Logger.warning("Eucalyptus[:storage] is not recommended, use Storage[:eucalyptus] for portability")
          Fog::Storage.new(:provider => 'Eucalyptus')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Eucalyptus.services
    end

  end
end

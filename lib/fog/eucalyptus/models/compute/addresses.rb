require 'fog/core/collection'
require 'fog/aws/models/compute/address'

module Fog
  module Compute
    class Eucalyptus

      class Addresses < Fog::Collection

        attribute :filters
        attribute :server

        model Fog::Compute::Eucalyptus::Address

        # Used to create an IP address
        #
        # ==== Returns
        #
        #>> Eucalyptus.addresses.create
        #  <Fog::Eucalyptus::Compute::Address
        #    public_ip="4.88.524.95",
        #    server_id=nil
        #  >
        #
        # The IP address can be retrieved by running Eucalyptus.addresses.get("test").  See get method below.
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Eucalyptus.addresses.all
        #
        # ==== Returns
        #
        # Returns an array of all IP addresses
        #
        #>> Eucalyptus.addresses.all
        #  <Fog::Eucalyptus::Compute::Addresses
        #    filters={},
        #    server=nil
        #    [
        #      <Fog::Eucalyptus::Compute::Address
        #        public_ip="76.7.46.54",
        #        server_id=nil
        #      >,
        #      .......
        #      <Fog::Eucalyptus::Compute::Address
        #        public_ip="4.88.524.95",
        #        server_id=nil
        #      >
        #    ]
        #  >
        #>>

        def all(filters = filters)
          unless filters.is_a?(Hash)
            Fog::Logger.deprecation("all with #{filters.class} param is deprecated, use all('public-ip' => []) instead [light_black](#{caller.first})[/]")
            filters = {'public-ip' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_addresses(filters).body
          load(
            data['addressesSet'].map do |address|
              address.reject {|key, value| value.nil? || value.empty? }
            end
          )
          if server
            self.replace(self.select {|address| address.server_id == server.id})
          end
          self
        end

        # Used to retrieve an IP address
        #
        # public_ip is required to get the associated IP information.
        #
        # You can run the following command to get the details:
        # Eucalyptus.addresses.get("76.7.46.54")

        def get(public_ip)
          if public_ip
            self.class.new(:connection => connection).all('public-ip' => public_ip).first
          end
        end

        def new(attributes = {})
          if server
            super({ :server => server }.merge!(attributes))
          else
            super(attributes)
          end
        end

      end

    end
  end
end

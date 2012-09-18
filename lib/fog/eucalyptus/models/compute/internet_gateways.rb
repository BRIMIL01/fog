require 'fog/core/collection'
require 'fog/aws/models/compute/internet_gateway'

module Fog
  module Compute
    class Eucalyptus

      class InternetGateways < Fog::Collection

        attribute :filters

        model Fog::Compute::Eucalyptus::InternetGateway

        # Creates a new internet gateway
        #
        # Eucalyptus.internet_gateways.new
        #
        # ==== Returns
        #
        # Returns the details of the new InternetGateway
        #
        #>> Eucalyptus.internet_gateways.new
        #=>   <Fog::Compute::Eucalyptus::InternetGateway
        #id=nil,
        #attachment_set=nil,
        #tag_set=nil
        #>
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Returns an array of all InternetGateways that have been created
        #
        # Eucalyptus.internet_gateways.all
        #
        # ==== Returns
        #
        # Returns an array of all InternetGateways
        #
        #>> Eucalyptus.internet_gateways.all
        #<Fog::Compute::Eucalyptus::InternetGateways
        #filters={}
        #[
        #<Fog::Compute::Eucalyptus::InternetGateway
        #id="igw-some-id",
        #attachment_set={"vpcId"=>"vpc-some-id", "state"=>"available"},
        #tag_set={}
        #>
        #]
        #>
        #

        def all(filters = filters)
          unless filters.is_a?(Hash)
            Fog::Logger.warning("all with #{filters.class} param is deprecated, use all('internet-gateway-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'internet-gateway-id' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_internet_gateways(filters).body
          load(data['internetGatewaySet'])
        end

        # Used to retrieve an InternetGateway
        #
        # You can run the following command to get the details:
        # Eucalyptus.internet_gateways.get("igw-12345678")
        #
        # ==== Returns
        #
        #>> Eucalyptus.internet_gateways.get("igw-12345678")
        #=>   <Fog::Compute::Eucalyptus::InternetGateway
        #id="igw-12345678",
        #attachment_set={"vpcId"=>"vpc-12345678", "state"=>"available"},
        #tag_set={}
        #>
        #

        def get(internet_gateway_id)
          if internet_gateway_id
            self.class.new(:connection => connection).all('internet-gateway-id' => internet_gateway_id).first
          end
        end

      end

    end
  end
end

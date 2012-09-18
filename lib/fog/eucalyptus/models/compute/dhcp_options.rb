require 'fog/core/collection'
require 'fog/aws/models/compute/dhcp_option'

module Fog
  module Compute
    class Eucalyptus

      class DhcpOptions < Fog::Collection

        attribute :filters

        model Fog::Compute::Eucalyptus::DhcpOption

        # Creates a new dhcp option
        #
        # Eucalyptus.dhcp_options.new
        #
        # ==== Returns
        #
        # Returns the details of the new DHCP options
        #
        #>> Eucalyptus.dhcp_options.new
        #=>   <Fog::Compute::Eucalyptus::DhcpOption
        #id=nil,
        #dhcp_configuration_set=nil,
        #tag_set=nil
        #>
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Returns an array of all DhcpOptions that have been created
        #
        # Eucalyptus.dhcp_options.all
        #
        # ==== Returns
        #
        # Returns an array of all DhcpOptions
        #
        #>> Eucalyptus.dhcp_options.all
        #<Fog::Compute::Eucalyptus::DhcpOptions
        #filters={}
        #[
        #<Fog::Compute::Eucalyptus::DhcpOption
        #id="dopt-some-id",
        #dhcp_configuration_set={"vpcId"=>"vpc-some-id", "state"=>"available"},
        #tag_set={}
        #>
        #]
        #>
        #

        def all(filters = filters)
          unless filters.is_a?(Hash)
            Fog::Logger.warning("all with #{filters.class} param is deprecated, use all('internet-gateway-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'dhcp-options-id' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_dhcp_options(filters).body
          load(data['dhcpOptionsSet'])
        end

        # Used to retrieve an DhcpOption
        #
        # You can run the following command to get the details:
        # Eucalyptus.dhcp_options.get("dopt-12345678")
        #
        # ==== Returns
        #
        #>> Eucalyptus.dhcp_options.get("dopt-12345678")
        #=>   <Fog::Compute::Eucalyptus::DhcpOption
        #id="dopt-12345678",
        #dhcp_configuration_set={"vpcId"=>"vpc-12345678", "state"=>"available"},
        #tag_set={}
        #>
        #

        def get(dhcp_options_id)
          if dhcp_options_id
            self.class.new(:connection => connection).all('dhcp-options-id' => dhcp_options_id).first
          end
        end

      end

    end
  end
end

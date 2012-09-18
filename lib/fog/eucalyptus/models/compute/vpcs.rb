require 'fog/core/collection'
require 'fog/aws/models/compute/vpc'

module Fog
  module Compute
    class Eucalyptus

      class Vpcs < Fog::Collection

        attribute :filters

        model Fog::Compute::Eucalyptus::VPC

        # Creates a new VPC
        #
        # Eucalyptus.vpcs.new
        #
        # ==== Returns
        #
        # Returns the details of the new VPC
        #
        #>> Eucalyptus.vpcs.new
        # <Fog::Eucalyptus::VPC::VPC
        # id=nil,
        # state=nil,
        # cidr_block=nil,
        # dhcp_options_id=nil
        # tags=nil
        # tenancy=nil
        # >
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Returns an array of all VPCs that have been created
        #
        # Eucalyptus.vpcs.all
        #
        # ==== Returns
        #
        # Returns an array of all VPCs
        #
        #>> Eucalyptus.vpcs.all
        # <Fog::Eucalyptus::VPC::VPCs
        # filters={}
        # [
        # <Fog::Eucalyptus::VPC::VPC
        # id="vpc-12345678",
        # TODO
        # >
        # ]
        # >
        #

        def all(filters = filters)
          unless filters.is_a?(Hash)
            Fog::Logger.warning("all with #{filters.class} param is deprecated, use all('vpc-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'vpc-id' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_vpcs(filters).body
          load(data['vpcSet'])
        end

        # Used to retrieve a VPC
        # vpc_id is required to get the associated VPC information.
        #
        # You can run the following command to get the details:
        # Eucalyptus.vpcs.get("vpc-12345678")
        #
        # ==== Returns
        #
        #>> Eucalyptus.vpcs.get("vpc-12345678")
        # <Fog::Eucalyptus::Compute::VPC
        # id="vpc-12345678",
        # TODO
        # >
        #

        def get(vpc_id)
          if vpc_id
            self.class.new(:connection => connection).all('vpc-id' => vpc_id).first
          end
        end

      end

    end
  end
end

require 'fog/core/collection'
require 'fog/eucalyptus/models/compute/security_group'

module Fog
  module Compute
    class Eucalyptus

      class SecurityGroups < Fog::Collection

        attribute :filters

        model Fog::Compute::Eucalyptus::SecurityGroup

        # Creates a new security group
        #
        # Eucalyptus.security_groups.new
        #
        # ==== Returns
        #
        # Returns the details of the new image
        #
        #>> Eucalyptus.security_groups.new
        #  <Fog::Eucalyptus::Compute::SecurityGroup
        #    name=nil,
        #    description=nil,
        #    ip_permissions=nil,
        #    owner_id=nil
        #    vpc_id=nil
        #  >
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Returns an array of all security groups that have been created
        #
        # Eucalyptus.security_groups.all
        #
        # ==== Returns
        #
        # Returns an array of all security groups
        #
        #>> Eucalyptus.security_groups.all
        #  <Fog::Eucalyptus::Compute::SecurityGroups
        #    filters={}
        #    [
        #      <Fog::Eucalyptus::Compute::SecurityGroup
        #        name="default",
        #        description="default group",
        #        ip_permissions=[{"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>-1, "toPort"=>-1, "ipRanges"=>[], "ipProtocol"=>"icmp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"tcp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"udp"}],
        #        owner_id="312571045469"
        #        vpc_id=nill
        #      >
        #    ]
        #  >
        #

        def all(filters = filters)
          unless filters.is_a?(Hash)
            Fog::Logger.deprecation("all with #{filters.class} param is deprecated, use all('group-name' => []) instead [light_black](#{caller.first})[/]")
            filters = {'group-name' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_security_groups(filters).body
          load(data['securityGroupInfo'])
        end

        # Used to retrieve a security group
        # group name is required to get the associated flavor information.
        #
        # You can run the following command to get the details:
        # Eucalyptus.security_groups.get("default")
        #
        # ==== Returns
        #
        #>> Eucalyptus.security_groups.get("default")
        #  <Fog::Eucalyptus::Compute::SecurityGroup
        #    name="default",
        #    description="default group",
        #    ip_permissions=[{"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>-1, "toPort"=>-1, "ipRanges"=>[], "ipProtocol"=>"icmp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"tcp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"udp"}],
        #    owner_id="312571045469"
        #    vpc_id=nil
        #  >
        #

        def get(group_name)
          if group_name
            self.class.new(:connection => connection).all('group-name' => group_name).first
          end
        end

        # Used to retrieve a security group
        # group id is required to get the associated flavor information.
        #
        # You can run the following command to get the details:
        # Eucalyptus.security_groups.get_by_id("default")
        #
        # ==== Returns
        #
        #>> Eucalyptus.security_groups.get_by_id("sg-123456")
        #  <Fog::Eucalyptus::Compute::SecurityGroup
        #    name="default",
        #    description="default group",
        #    ip_permissions=[{"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>-1, "toPort"=>-1, "ipRanges"=>[], "ipProtocol"=>"icmp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"tcp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"udp"}],
        #    owner_id="312571045469"
        #  >
        #

        def get_by_id(group_id)
          if group_id
            self.class.new(:connection => connection).all('group-id' => group_id).first
          end
        end
      end

    end
  end
end

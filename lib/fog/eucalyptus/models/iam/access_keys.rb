require 'fog/core/collection'
require 'fog/eucalyptus/models/iam/access_key'

module Fog
  module Eucalyptus
    class IAM

      class AccessKeys < Fog::Collection
    
        model Fog::Eucalyptus::IAM::AccessKey
        
        def initialize(attributes = {})
          @username = attributes[:username]
          raise ArgumentError.new("Can't get an access_key's user without a username") unless @username
          super
        end
        
        def all 
          data = connection.list_access_keys('UserName'=> @username).body['AccessKeys']
          # Eucalyptus response doesn't contain the UserName, this injects it
          data.each {|access_key| access_key['UserName'] = @username }
          load(data)
        end

        def get(identity)
          self.all.select {|access_key| access_key.id == identity}.first
        end
        
        def new(attributes = {})
          super({ :username => @username }.merge!(attributes))
        end

      end
    end
  end
end

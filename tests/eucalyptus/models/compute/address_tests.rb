Shindo.tests("Fog::Compute[:eucalyptus] | address", ['eucalyptus']) do

  model_tests(Fog::Compute[:eucalyptus].addresses, {}, true) do

    @server = Fog::Compute[:eucalyptus].servers.create
    @server.wait_for { ready? }

    tests('#server=').succeeds do
      @instance.server = @server
    end

    tests('#server') do
      test(' == @server') do
        @server.reload
        @instance.server.public_ip_address == @instance.public_ip
      end
    end

    @server.destroy

  end
end

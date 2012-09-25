Shindo.tests("Fog::Compute[:eucalyptus] | volume", ['eucalyptus']) do

  @server = Fog::Compute[:eucalyptus].servers.create
  @server.wait_for { ready? }

  model_tests(Fog::Compute[:eucalyptus].volumes, {:availability_zone => @server.availability_zone, :size => 1, :device => '/dev/sdz1', :tags => {"key" => "value"}}, true) do

    @instance.wait_for { ready? }

    tests('#server = @server').succeeds do
      @instance.server = @server
    end

    @instance.wait_for { state == 'in-use' }

    tests('#server').succeeds do
      @instance.server
    end

    tests('#server = nil').succeeds do
      (@instance.server = nil).nil?
    end

    @instance.wait_for { ready? }

    @instance.server = @server
    @instance.wait_for { state == 'in-use' }

    tests('#force_detach').succeeds do
      @instance.force_detach
    end

    @instance.wait_for { ready? }

    tests('@instance.reload.tags').returns({'key' => 'value'}) do
      @instance.reload.tags
    end

  end

  @server.destroy

end

Shindo.tests("Fog::Compute[:eucalyptus] | snapshot", ['eucalyptus']) do

  @volume = Fog::Compute[:eucalyptus].volumes.create(:availability_zone => 'eucalyptus', :size => 1)
  @volume.wait_for { ready? }

  model_tests(Fog::Compute[:eucalyptus].snapshots, {:volume_id => @volume.identity}, true)

  @volume.destroy

end

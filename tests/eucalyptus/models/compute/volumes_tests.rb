Shindo.tests("Fog::Compute[:eucalyptus] | volumes", ['eucalyptus']) do

  collection_tests(Fog::Compute[:eucalyptus].volumes, {:availability_zone => 'eucalyptus', :size => 1, :device => '/dev/sdz1'}, true)

end

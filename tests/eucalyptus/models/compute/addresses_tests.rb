Shindo.tests("Fog::Compute[:eucalyptus] | addresses", ['eucalyptus']) do

  collection_tests(Fog::Compute[:eucalyptus].addresses, {}, true)

end

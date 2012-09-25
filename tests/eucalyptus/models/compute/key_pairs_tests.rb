Shindo.tests("Fog::Compute[:eucalyptus] | key_pairs", ['eucalyptus']) do

  collection_tests(Fog::Compute[:eucalyptus].key_pairs, {:name => 'fogkeyname'}, true)

end

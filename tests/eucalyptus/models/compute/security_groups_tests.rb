Shindo.tests("Fog::Compute[:eucalyptus] | security_groups", ['eucalyptus']) do

  collection_tests(Fog::Compute[:eucalyptus].security_groups, {:description => 'foggroupdescription', :name => 'foggroupname'}, true)

end

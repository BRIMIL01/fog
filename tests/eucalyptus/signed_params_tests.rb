# encoding: utf-8

Shindo.tests('Eucalyptus | signed_params', ['aws']) do
  returns( Fog::Eucalyptus.escape( "'Stöp!' said Fred_-~." ) ) { "%27St%C3%B6p%21%27%20said%20Fred_-~." }
end

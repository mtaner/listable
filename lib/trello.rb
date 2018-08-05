trello_lib = File.expand_path(__dir__)
$LOAD_PATH.unshift(trello_lib) unless $LOAD_PATH.include?(trello_lib)

require 'active_support/all'
require 'trello/initializers/redis'

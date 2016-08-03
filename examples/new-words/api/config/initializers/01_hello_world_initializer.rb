regexp = %r{\A.*(config/initializers/.*\.rb)\Z}
match = regexp.match(__FILE__)

puts "Initializer '#{match[1]}' is called"

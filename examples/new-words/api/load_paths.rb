[File.dirname(__FILE__), File.join(File.dirname(__FILE__), 'lib')].each do |p|
  $LOAD_PATH.unshift(p) unless $LOAD_PATH.include?(p)
end

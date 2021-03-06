require "./lib/shake"
Gem::Specification.new do |s|
  s.name = "shake"
  s.version = Shake::VERSION
  s.summary = %{Simple command line runner.}
  s.description = %Q{Shake is a simple replacement for Thor/Rake.}
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/rstacruz/shake"
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }
end

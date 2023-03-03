require "rubygems/package_task"
require "rake/packagetask"

spec = Gem::Specification.load("summarize-meeting.gemspec")

Gem::PackageTask.new(spec) do |pkg|
  pkg.package_dir = "pkg"
end

task release: [:package] do
  files = Dir.glob("pkg/*.gem")
  gem_file = files.sort.last
  sh "gem push #{gem_file}"
end

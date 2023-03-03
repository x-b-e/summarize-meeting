require "rubygems/package_task"
require "rake/packagetask"

spec = Gem::Specification.load("summarize-meeting.gemspec")

Gem::PackageTask.new(spec) do |pkg|
  pkg.package_dir = "pkg"
end

task release: [:package] do
  gem_file = Dir.glob("pkg/*.gem").first
  sh "gem push #{gem_file}"
end
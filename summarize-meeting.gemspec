Gem::Specification.new do |s|
  s.name        = "summarize-meeting"
  s.version     = "0.2.0"
  s.summary     = "A command line utility that summarizes a meeting"
  s.description = "A command line utility that summarizes a meeting using generative language models."
  s.license     = "MIT"

  s.authors     = ["Sean Devine"]
  s.email       = "sean-devine@x-b-e.com"

  s.files       = [
    "lib/summarize-meeting.rb",
    "lib/summarize-meeting/version.rb",
    "lib/summarize-meeting/ai.rb",
    "lib/summarize-meeting/meeting.rb",
    "bin/summarize-meeting",
    "README.md",
    "LICENSE.txt"
  ]
  s.bindir      = "bin"
  s.executables << "summarize-meeting"
  s.require_path = ["lib"]

  s.add_dependency "optparse"
  s.add_dependency "ruby-openai"
  s.add_dependency "mustache"

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
  s.add_development_dependency "dotenv"
end
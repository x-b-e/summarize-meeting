Gem::Specification.new do |s|
  s.name        = "summarize-meeting"
  s.version     = '0.1.0'
  s.summary     = "A command line utility that summarizes a meeting"
  s.description = "A command line utility that summarizes a meeting using generative language models."

  s.authors     = ["Sean Devine"]
  s.email       = "sean-devine@x-b-e.com"

  s.files       = [*Dir.glob("lib/**/*"), "bin/summarize-meeting.rb"]
  s.executables = ["summarize-meeting.rb"]
  s.require_path = '.'

  s.add_dependency "optparse"
  s.add_dependency "dotenv"
  s.add_dependency "ruby-openai"
  s.add_dependency "mustache"

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
end
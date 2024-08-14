require_relative 'lib/short_io/version'

Gem::Specification.new do |spec|
  spec.name          = "short_io"
  spec.version       = ShortIo::VERSION
  spec.authors       = ["Yosef Benny Widyokarsono"]
  spec.email         = ["yosefbennywidyo@gmail.com"]

  spec.summary       = %q{Create short branded URLs with Short.io}
  spec.homepage      = "https://github.com/yosefbennywidyo/short_io"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Only for private gems to prevent accidential pushes to rubygems.org
  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yosefbennywidyo/short_io"
  spec.metadata["changelog_uri"] = "https://github.com/yosefbennywidyo/short_io/blob/main/CHANGELOG.md"
  spec.metadata["github_repo"] = "https://github.com/yosefbennywidyo/short_io"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

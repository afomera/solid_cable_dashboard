# frozen_string_literal: true

require_relative "lib/solid_cable_dashboard/version"

Gem::Specification.new do |spec|
  spec.name = "solid_cable_dashboard"
  spec.version = SolidCableDashboard::VERSION
  spec.authors = ["Andrea Fomera"]
  spec.email = ["afomera@hey.com"]

  spec.summary = "Solid Cable Dashboard"
  spec.description = "Dashboard for Solid Cable"
  spec.homepage = "https://github.com/afomera/solid_cable_dashboard"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/afomera/solid_cable_dashboard"
  spec.metadata["changelog_uri"] = "https://github.com/afomera/solid_cable_dashboard/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |filename|
      (filename == gemspec) ||
        filename.start_with?(*%w[bin/ test/ spec/ features/ test_app/ docs/ .git .github Gemfile]) ||
        filename.end_with?(".gem") # Exclude gem files
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "solid_cable", ">= 0.1.0"
  spec.add_dependency "groupdate", ">= 6.5"
  spec.add_dependency "chartkick", ">= 5.0"
  spec.add_dependency "pagy", ">= 6.0"
end

source "https://rubygems.org"
# Jekyll 4.x — required by jekyll-theme-chirpy.
# Deploy via GitHub Actions (see .github/workflows/pages-deploy.yml);
# the jekyll-theme-chirpy gem is not on the GitHub Pages safe-list.
gem "jekyll", "~> 4.3"
gem "jekyll-theme-chirpy", "~> 7.5"

# Plugins — chirpy pulls jekyll-seo-tag, jekyll-archives, and jekyll-sitemap
# as dependencies. jekyll-feed is omitted because Chirpy ships its own
# assets/feed.xml template which would conflict.

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]

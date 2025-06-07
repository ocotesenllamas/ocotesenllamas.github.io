# Display current Ruby version
echo "Ruby version"
ruby -v

# Display current Jekyll version
echo "Jekyll version"
jekyll -v
# Update gems
echo "bundle install"
bundle install
echo "bundle update"
bundle update

# Get the presumed value for the baseurl (this folder name)
var=$(pwd)
BASEURL="$(basename $PWD)"
echo "    bundle exec jekyll serve --livereload "
echo "    Look for the site at port 4000 (ex http://127.0.0.1:4000/)"-
echo " JEKYLL_ENV=production bundle exec jekyll build "

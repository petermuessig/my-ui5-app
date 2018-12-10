#!/bin/bash

/*
 * Tutorial: https://voorhoede.github.io/front-end-tooling-recipes/travis-deploy-to-gh-pages/
 * Script origin: https://github.com/voorhoede/front-end-tooling-recipes/blob/master/travis-deploy-to-gh-pages/scripts/deploy.sh
 * travis encrypt -r petermuessig/my-ui5-app GH_TOKEN=<MY_GH_TOKEN> --add env.global
 */

set -e # exit with nonzero exit code if anything fails

if [[ $TRAVIS_BRANCH == "master" && $TRAVIS_PULL_REQUEST == "false" ]]; then

echo "Starting to update gh-pages\n"

#copy data we're interested in to other place
cp -R dist $HOME/dist

#go to home and setup git
cd $HOME
git config --global user.email "openui5@sap.com"
git config --global user.name "OpenUI5"

#using token clone gh-pages branch
git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git gh-pages > /dev/null

#go into directory and copy data we're interested in to that directory
cd gh-pages
cp -Rf $HOME/dist/* .

echo "Allow files with underscore https://help.github.com/articles/files-that-start-with-an-underscore-are-missing/" > .nojekyll
echo "[View live](https://${GH_USER}.github.io/${GH_REPO}/)" > README.md

#add, commit and push files
git add -f .
git commit -m "Travis build $TRAVIS_BUILD_NUMBER"
git push -fq origin gh-pages > /dev/null

echo "Done updating gh-pages\n"

else
 echo "Skipped updating gh-pages, because build is not triggered from the master branch."
fi;
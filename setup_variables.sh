#!/bin/bash

locate=$1

fetch_maven() {
    echo $(mvn help:evaluate -Dexpression=$1 -q -DforceStdout -f $locate/pom.xml)
}

# fetch maven version
echo "Fetching maven version..."
version=$(fetch_maven "project.version")
echo "Fetched success. The Project version is $version"

artifact=$3

if [ $artifact = "NONE" ] # didn't provid the artifact name
then
     # fetch maven build final name
    echo "Fetching maven build final name..."
    artifact=$(fetch_maven "project.build.finalName")
    echo "Fetched success, The project build final name will be $artifact"
else
    artifact="$3-$version"
    echo "Using provided artifact name, The project build final name will be $artifact"
fi


jdk_version=$2

if [ -z $jdk_version ] || [ $jdk_version = "NONE" ]
then
  # fetch maven build jdk version
  echo "Not providing jdk version, Fetching maven build jdk version..."
  jdk_version=$(fetch_maven "maven.compiler.target")

  if [ ! $? -eq 0 ]
  then
    echo "Cannot find version from either maven.compiler.target or inputs."
    exit 1
  fi

  echo "Fetched success, the project jdk version is $jdk_version"
fi

# set output variables
echo "::set-output name=version::$version"
echo "::set-output name=artifact::$artifact"
echo "::set-output name=jdk-version::$jdk_version"

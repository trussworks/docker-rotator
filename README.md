# docker-rotator

[![CircleCI](https://circleci.com/gh/trussworks/docker-rotator/tree/master.svg?style=svg)](https://circleci.com/gh/trussworks/docker-rotator/tree/master)

This image is used to rotate AWS IAM credentials on a regular schedule.

This docker image is built off of CircleCI's most basic convenience image [`cimg/base`](https://hub.docker.com/r/cimg/base) with the following tools installed on top:

- [AWS CLI](https://aws.amazon.com/cli/)
- [rotator](https://github.com/chanzuckerberg/rotator)

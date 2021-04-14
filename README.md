# Docker images tagging

[![CircleCI Build Status](https://circleci.com/gh/Jahia/docker-tags-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/Jahia/docker-tags-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/jahia/docker-tags-orb)](https://circleci.com/orbs/registry/orb/jahia/docker-tags-orb) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Jahia/docker-tags-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)



A CircleCI orb to facilitate the tagging of Docker images and the creation of shorter versions of the tags acting as aliases to full versions of the image.

When provided with a version, the Orb will automatically check other versions already published to the registry (only Docker Hub for now) and determine all of the tags that needs to be generated.

For example, if releasing version 8.2.0.1, the orb will automatically created the following alliases:
* 8
* 8.2
* 8.2.0

The objective is to allow CI/CD platforms to automatically use the "latest" of the selected flavor, for example latest 8, lasted 8.0, latest 8.0.2

This orb also supports SNAPSHOT tagging. Snapshot and release tags are not mixed.

Note: Due to Docker Layer caching, generating additonal tags does not increase resource usage.

# Use Cases

Assuming the following tags already exist in Docker hub.

```
7.3.4.1
7.3.4.2
7.3.5.0
7.3.5.1
7.3.6.0
7.3.7.0
8.0.0.0
8.0.1.0
8.0.2.0
```

## When submitting 8.0.2.0

```
All versions : 7.3.4.1 7.3.4.2 7.3.5.0 7.3.5.1 7.3.6.0 7.3.7.0 8.0.0.0 8.0.1.0 8.0.2.0
latest is : 8.0.2.0 , require tag update
8 is : 8.0.2.0 , require tag update
8.0 is : 8.0.2.0 , require tag update
8.0.2 is : 8.0.2.0 , require tag update
```


## When submitting 7.3.7.0

```
All versions : 7.3.4.1 7.3.4.2 7.3.5.0 7.3.5.1 7.3.6.0 7.3.7.0 8.0.0.0 8.0.1.0 8.0.2.0
latest is : 8.0.2.0 , unchanged
7 is : 7.3.7.0 , require tag update
7.3 is : 7.3.7.0 , require tag update
7.3.7 is : 7.3.7.0 , require tag update
```

## When submitting 7.3.5.1

```
All versions : 7.3.4.1 7.3.4.2 7.3.5.0 7.3.5.1 7.3.6.0 7.3.7.0 8.0.0.0 8.0.1.0 8.0.2.0
latest is : 8.0.2.0 , unchanged
7 is : 7.3.7.0 , unchanged
7.3 is : 7.3.7.0 , unchanged
7.3.5 is : 7.3.5.1 , require tag update
```

## When submitting 7.3.5.0

```
7.3.5.0
All versions : 7.3.4.1 7.3.4.2 7.3.5.0 7.3.5.1 7.3.6.0 7.3.7.0 8.0.0.0 8.0.1.0 8.0.2.0
latest is : 8.0.2.0 , unchanged
7 is : 7.3.7.0 , unchanged
7.3 is : 7.3.7.0 , unchanged
7.3.5 is : 7.3.5.1 , unchanged
```

## When submitting 8.0.1.1

Submitting a version that does not exist yet in the docker registry

```
8.0.1.1 not found yet, adding it
All versions : 7.3.4.1 7.3.4.2 7.3.5.0 7.3.5.1 7.3.6.0 7.3.7.0 8.0.0.0 8.0.1.0 8.0.1.1 8.0.2.0
latest is : 8.0.2.0 , unchanged
8 is : 8.0.2.0 , unchanged
8.0 is : 8.0.2.0 , unchanged
8.0.1 is : 8.0.1.1 , require tag update 
```

## When submitting 8.0.3.0-SNAPSHOT

```
8.0.3.0-SNAPSHOT not found yet, adding it
All versions : 8.0.3.0-SNAPSHOT
latest-SNAPSHOT is : 8.0.3.0-SNAPSHOT , require tag update
8-SNAPSHOT is : 8.0.3.0-SNAPSHOT , require tag update
8.0-SNAPSHOT is : 8.0.3.0-SNAPSHOT , require tag update
8.0.3-SNAPSHOT is : 8.0.3.0-SNAPSHOT , require tag upda
```

# Development

Complex orbs can be found here:
 * https://github.com/CircleCI-Public/slack-orb
 * https://github.com/CircleCI-Public/orb-tools-orb


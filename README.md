# WP Engine + Codeship Continuous Deployment/Delivery

Love WordPress? Love WP Engine and want to take advantage of their git deployment but have need to have more flexiblity to deploy multiple repos? This script will assist automatically deploying WordPress plugins and themes to WP Engine .git deployment using Codeship or other deployment services.

At Linchpin we use WP Engine and Codeship and love both. Hopefully you find this useful. This document also assumes you are using codeship as your CI/CD solution so you _may_ need to make adjustments based on deploybot or another service.

# Beta Public Release Version 1.0

### How do I get set up? ###

* Configuration
* Environment Variables
* Deployment instructions
* What this repo needs

### What does this repo need ###

* Writing tests
* Code review
* Complete documentation for usage (setup pipelines, testing etc).

### Configuration ###

1. Log into **codeship.com** or your deployment method of choice.
2. Connect your **bitbucket**, **github** or **gitlab** repo to codeship.
3. Setup Environment Variables
    Environment variables are a great way to add flexibility to the script with out having variables hard coded within this script.
    You should never have any credentials stored within this or any other repo.
4. Create deployment pipeline for each branch you going to add automated deployments to **"master"** and **"staging"**. The pipelines you create are going to utilize teh **deployment Script below**
5. Do a test push to the repo.
6. Create deployment pipeline for **"staging"**

### Environment Variables

All of the environment variables below are required

* **REPO_NAME** : The repo name should match the theme / plugin folder name
* **HOST_NAME** : The hostname from WP Engine
* **PROJECT_TYPE** : (**"theme"** or **"plugin"**)

### Deployment Script

The below build script will check out the linchpin build scripts from bitbucket and then run the bash script accordingly based on the environment variables.

```
# load our build script from the linchpin repo
git clone --branch "master" --depth 50 git@github.com:linchpin/wpengine-codeship-continuous-deployment.git
./build-scripts/wpengine-build
```


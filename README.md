# WP Engine + Codeship Continuous Deployment/Delivery

Love WordPress? Love WP Engine and want to take advantage of their git deployment but need to have more flexiblity to deploy multiple repos? This script will assist you in automatically deploying WordPress plugins and themes to [WP Engine .git deployment](https://wpengine.com/git/) using [Codeship](https://codeship.com) or other deployment services.

At [Linchpin](https://linchpin.agency) we use [WP Engine](https://www.wpengine.com) and [Codeship](https://www.codeship.com) and love both. Hopefully you find this shell script useful.

# Beta Public Release Version 1.0

# The instructions and the deployment script assumes this following

* You are using Codeship as your CI/CD solution so you _may_ need to make adjustments based on deploybot or another service.
* You understand how to setup [.git deployments on WP Engine](https://wpengine.com/git/) already.
* You are using the **master** branch of your repo for **production**
* You are using the **develop** branch of your repo for **staging**

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
4. Create deployment pipeline for each branch you going to add automated deployments to **"master"** and **"staging"**. The pipelines you create are going to utilize the **deployment script below**
5. Do a test push to the repo.
6. Create deployment pipeline for **"staging"**

### Environment Variables

All of the environment variables below are required

* **REPO_NAME** : The repo name should match the theme / plugin folder name
* **HOST_NAME** : The hostname from WP Engine
* **PROJECT_TYPE** : (**"theme"** or **"plugin"**)

### Deployment Script

The below build script will check out the linchpin build scripts from github and then run the shell script accordingly based on the environment variables.

In the example below you will see this script is specifcally for **master** if you wanted to use this for staging you would setup a deployment that targets **develop** specifically and update the `git clone --branch "master"` line to `git clone --branch "develop"`

## deploying to master
```
# load our build script from the linchpin repo
git clone --branch "master" --depth 50 git@github.com:linchpin/wpengine-codeship-continuous-deployment.git
./wpengine-codeship-continuous-deployment/deploy.sh
```

## deploying to staging
```
# load our build script from the linchpin repo
git clone --branch "develop" --depth 50 git@github.com:linchpin/wpengine-codeship-continuous-deployment.git
./wpengine-codeship-continuous-deployment/deploy.sh
```

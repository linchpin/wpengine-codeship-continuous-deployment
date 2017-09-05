# WP Engine + Codeship Continuous Deployment/Delivery

Love WordPress? Love WP Engine and want to take advantage of their git deployment but need to have more flexiblity to deploy multiple repos? This script will assist you in automatically deploying WordPress plugins and themes to [WP Engine .git deployment](https://wpengine.com/git/) using [Codeship](https://codeship.com) or other deployment services.

At [Linchpin](https://linchpin.agency) we use [WP Engine](https://www.wpengine.com) and [Codeship](https://www.codeship.com) and love both. Hopefully you find this shell script useful.

# Beta Public Release Version 1.0

### The instructions and the deployment script assumes this following

* You are using Codeship as your CI/CD solution so you _may_ need to make adjustments based on deploybot or another service.
* You understand how to setup [.git deployments on WP Engine](https://wpengine.com/git/) already.
* You are using the **master** branch of your repo for **production**
* You are using the **develop** branch of your repo for **staging**

### How do I get set up?

* [Preflight Repo Setup](https://github.com/linchpin/wpengine-codeship-continuous-deployment#preflight-repo-setup)
* [Configuration](https://github.com/linchpin/wpengine-codeship-continuous-deployment#configuration)
* [Codeship Environment Variables](https://github.com/linchpin/wpengine-codeship-continuous-deployment#codeship-environment-variables)
* Deployment instructions
* [Useful notes](https://github.com/linchpin/wpengine-codeship-continuous-deployment#useful-notes)
* What this repo needs

### Preflight Repo Setup

When creating your repo, it's important to name the repo using proper folder structure. We typically replace any spaces " " with dashes "-".**Example:** If your plugin is named "My Awesome Plugin" you can name the repo "my-awesome-plugin". When the script runs it will use the `REPO_NAME` environment variable as the folder for your plugin or theme. So you may find it useful to match.

**Important Note:** All assets/files within your repo should be within the root folder. **DO NOT** include `wp-content`, `wp-content\plugins` etc. The deploy script will create all the appropriate folders as needed.

### Configuration

1. Log into **codeship.com** or your deployment method of choice.
2. Connect your **bitbucket**, **github** or **gitlab** repo to codeship.
3. Setup Environment Variables
    * Environment variables are a great way to add flexibility to the script with out having variables hard coded within this script.
    * You should never have any credentials stored within this or any other repo.
4. Create deployment pipeline for each branch you going to add automated deployments to **"master"** and **"staging"**. The pipelines you create are going to utilize the **deployment script below**
5. Do a test push to the repo. The first time you do this within Codeship it may be beneficial to watch all the steps that are displayed within their helpful console.

### Codeship Environment Variables

All of the environment variables below are required

|Varible|Description|Required|
| ------------- | ------------- | ------------- |
|**REPO_NAME**|The repo name should match the theme / plugin folder name|:heavy_exclamation_mark:|
|**WPE_INSTALL**|The subdomain from WP Engine|:heavy_exclamation_mark:|
|**PROJECT_TYPE**|(**"theme"** or **"plugin"**) This really just determines what folder your repo is in|:heavy_exclamation_mark:|
|**EXCLUDE_LIST**|Custom list of files/directories that will be used to exclude files from deploymnet. This shell script provides a default. This Environment variable is only needed if you are customizing for your own usage. This variable should be a FULL URL to a file. See exclude-list.txt for an example| Optional

### Commit Message Hash Tags

* **#force** Some times you need to disregard what wpengine has within their remote repo and start fresh. [Read more](https://wpengine.com/support/resetting-your-git-push-to-deploy-repository/) about it on WP Engine.

## Deployment Instructions (The Script)

The below build script(s) will check out the linchpin build scripts from github and then run the shell script accordingly based on the environment variables.

In the script below you will see this script is specifcally for **master** if you wanted to use this for staging you would setup a deployment that targets **develop** specifically and update the `git clone --branch "master"` line to `git clone --branch "develop"`

### deploying to master
```
# load our build script from the linchpin repo
git clone --branch "master" --depth 50 git@github.com:linchpin/wpengine-codeship-continuous-deployment.git
chmod 555 ./wpengine-codeship-continuous-deployment/wpengine.sh
./wpengine-codeship-continuous-deployment/deploy.sh
```

### deploying to staging
```
# load our build script from the linchpin repo
git clone --branch "develop" --depth 50 git@github.com:linchpin/wpengine-codeship-continuous-deployment.git
chmod 555 ./wpengine-codeship-continuous-deployment/wpengine.sh
./wpengine-codeship-continuous-deployment/deploy.sh
```

## Useful Notes
* WP Engine's .git push can almost be considered a "middle man" between your repo and what is actually displayed to your visitors within the root web directory of your website. After the files are .git pushed to your production or staging remote branches they are then synced to the appropriate environment's webroot. It's important to know this because there are scenarios where you may need to use the **#force** hashtag within your commit message in order to override what WP Engine is storing within it's repo and what is shown when logged into SFTP. You can read more about it on [WP Engine](https://wpengine.com/support/resetting-your-git-push-to-deploy-repository/)

* If an SFTP user in WP Engine has uploaded any files to staging or production those assets **WILL NOT** be added to the repo.
* Additionally there are times where files need to deleted that are not associated with the repo. In these scenarios we suggest deleting the files using SFTP and then utilizing the **#force** hash tag within the next deployment you make.

### What does this repo need

* Tests and Validation
* Peer review
* Complete documentation for usage (setup pipelines, testing etc).

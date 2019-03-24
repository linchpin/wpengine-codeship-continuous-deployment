# WP Engine + Codeship Continuous Deployment/Delivery

Love WordPress? Love WP Engine and want to take advantage of their git deployment but need to have more flexiblity to deploy multiple repos? This script will assist you in automatically deploying WordPress plugins and themes to [WP Engine .git deployment](https://wpengine.com/git/) using [Codeship](https://codeship.com) or other deployment services.

At [Linchpin](https://linchpin.com) we use [WP Engine](https://www.wpengine.com) and [Codeship](https://www.codeship.com) and love both. Hopefully you find this shell script useful.

For a more indepth walk through please visit [this article](https://linchpin.agency/blog/continuous-deployment-wp-engine-codeship/?utm_source=github&utm_medium=deployments&utm_campaign=wpengine) on the Linchpin site.

# Public Release Version 2.0

### Important Changes Regarding the build process compared to v1

The latest version of this script will not only deploy your code, the latest version will also *build* your code as long as the script finds a `gulpfile`, `gruntfile`, `yarn` etc. In order to bild your project simply create a task in your task runner named `build:production`.

*Supports both WP Engine legacy and Multi environment sites (Legacy Staging or Dev, Staging, Production)*

### The instructions and the deployment script assumes the following

* You are using Codeship as your CI/CD solution so you _may_ need to make adjustments based on deploybot or another service.
* You understand how to setup [.git deployments on WP Engine](https://wpengine.com/git/) already.
* You are using the **master** branch of your repo for your **Production** instance
* You are using the **staging** branch of your repo for your **Staging** instance
* You are using the **develop** branch of your repo for your **Development** instance

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
2. Connect your **bitbucket**, **github** or **gitlab** repo to codeship. (You will need to authorize access to your repo)
3. Setup [Environment Variables](https://github.com/linchpin/wpengine-codeship-continuous-deployment#codeship-environment-variables)
    * Environment variables are a great way to add flexibility to the script with out having variables hard coded within this script.
    * You should never have any credentials stored within this or any other repo.
4. Create deployment pipeline for each branch you are going to add automated deployments to (For single install setups use **"master"** and **"develop"**. For multi-environment setups use **master**, **staging**, and **"develop"**). The pipelines you create are going to utilize the **deployment script below**
5. Do a test push to the repo. The first time you do this within Codeship it may be beneficial to watch all the steps that are displayed within their helpful console.

### Codeship Environment Variables

All of the environment variables below are required

|Variable|Description|Required|
| ------------- | ------------- | ------------- |
|**REPO_NAME**|The repo name should match the theme / plugin folder name|:heavy_exclamation_mark:|
|**WPE_INSTALL**|The subdomain of your WP Engine install **(This is for single installs only and is considered deprecated)**|:heavy_exclamation_mark:|
|**PROJECT_TYPE**|(**"theme"** or **"plugin"**) This really just determines what base folder your repo should be deployed to|:heavy_exclamation_mark:|


The variables below are not required, but are utilized to work with WP Engine's current multi-environment setup. Moving away from legacy staging, WP Engine now utilizes 3 individual installs under one "site". The are all essentially part of your same hosting environment, but are treated as Production, Staging, and Development environments when it comes to your workflow.

|Variable|Description|Required|
| ------------- | ------------- | ------------- |
|**WPE_INSTALL_PROD**|The subdomain from WP Engine install "Production"||
|**WPE_INSTALL_STAGE**|The subdomain from WP Engine install "Staging"||
|**WPE_INSTALL_DEV**|The subdomain from WP Engine install "Development"||


This variable is optional to source a custom excludes list file.

|Variable|Description|Required|
| ------------- | ------------- | ------------- |
|**EXCLUDE_LIST**|Custom list of files/directories that will be used to exclude files from deploymnet. This shell script provides a default. This Environment variable is only needed if you are customizing for your own usage. This variable should be a FULL URL to a file. See exclude-list.txt for an example| Optional

### Commit Message Hash Tags
You can customize the actions taken by the deployment script by utilizing the following hashtags within your commit message

|Commit #hashtag|Description|
| ------------- | ------------- |
|**#force**|Some times you need to disregard what WP Engine has within their remote repo(s) and start fresh. [Read more](https://wpengine.com/support/resetting-your-git-push-to-deploy-repository/) about it on WP Engine.|

## Deployment Instructions (The Script)

The below build script(s) will check out the linchpin build scripts from github and then run the shell script accordingly based on the environment variables.

In the script below you will see this script is specifcally for **master** if you wanted to use this for staging you would setup a deployment that targets **develop** specifically.

### deploying to your pipeline (master|develop - deprecated | or master|staging|develop)

In order to deploy to your pipeline you can use the following command regardless of master, develop or a custom branch. We are utilizing `https` instead of `SSH` so we can `git clone` the deployment script without requiring authentication.

```
# load our build script from the linchpin repo
git clone --branch "improvement/build-process" --depth 50 https://github.com/linchpin/wpengine-codeship-continuous-deployment.git
chmod 555 ./wpengine-codeship-continuous-deployment/build.sh
chmod 555 ./wpengine-codeship-continuous-deployment/deploy.sh
chmod 555 ./wpengine-codeship-continuous-deployment/build-deploy.sh
./wpengine-codeship-continuous-deployment/build-deploy.sh
```

## Useful Notes

* WP Engine's .git push can almost be considered a "middle man" between your repo and what is actually displayed to your visitors within the root web directory of your website. After the files are .git pushed to your production, staging, or develop remote branches they are then synced to the appropriate environment's webroot. It's important to know this because there are scenarios where you may need to use the **#force** hashtag within your commit message in order to override what WP Engine is storing within it's repo and what is shown when logged into SFTP. You can read more about it on [WP Engine](https://wpengine.com/support/resetting-your-git-push-to-deploy-repository/)

* If an SFTP user in WP Engine has uploaded any files to staging or production those assets **WILL NOT** be added to the repo.
* Additionally there are times where files need to deleted that are not associated with the repo. In these scenarios we suggest deleting the files using SFTP and then utilizing the **#force** hash tag within the next deployment you make.

### What does this repo need

* Tests and Validation
* Complete documentation for usage (setup pipelines, testing etc).

Introduction to CI/CD
===
Publish a simple FastAPI endpoint to Docker Hub using basic CI/CD workflow

## Testing & Linting
Inspect the [`pre-build.yaml`](https://github.com/jrpespinas/intro-to-cicd/blob/main/.github/workflows/pre-build.yaml) which contains the jobs for testing the API and checking the source code formatting.

This workflow triggers whenever we make a `pull request` to the `main` branch.

The `workflow_dispatch` is included as an option to manually trigger the workflow in Github using the browser.

The workflow has two jobs: `testing` and `linting`

### Testing

Under **testing**, we defined an optional `name` property to make it more readable when inspecting the job in the browser. This job must specify an operating system to execute on the runner using the `runs-on` property. The `steps` property define the steps of the job.

#### Steps:
1. **checkout repository onto the runner** - It uses the `uses` property to utilize a github action named `actions/checkout@v3` <br/><br /> Note: you may find more actions using the [github marketplace](https://github.com/marketplace?type=actions)
2. **setup python environment** - uses the `actions/setup-python@v4` to set the python version of the runner
3. **install dependencies** - it uses the `run` property to run the command `make pip-init` and `make build` which is found in our [makefile](https://github.com/jrpespinas/intro-to-cicd/blob/main/makefile) in the repository.
4. **pytest** - runs the `make test` to trigger the unit test

Once done, the runner will clean up the resources used and it will proceed to the next job.

### Linting
Similar to **testing**, we defined an operating system for it to run-on and the steps to perform this job. 

However, we only want this job to run after **testing** is successful, therefore we define a `needs` property and specify `testing` as the job we wait for to finish.

#### Steps:
1. **checkout repository onto the runner** - It uses the same action `actions/checkout@v3`<br /><br />Note: you have to checkout the repository as this job runs on a different runner instance.
2. **setup python environment**

3. **flake8 int** - we use an action from github marketplace to run a linting action in our runner to check for source code formatting

## Publishing

Inspect [`publish.yaml`](https://github.com/jrpespinas/intro-to-cicd/blob/main/.github/workflows/publish.yaml) which contains the `publishing` job.

This job only triggers whenever we `push` something to the `main` branch. This could be a commit or a merge.

Similar to [Testing & Linting](#testing--linting), we defined an operating system for the runner and the steps.

Notice that there is also a property called `env` that defines any variables that is repeatedly used through out the job. The `env` can be defined in the workflow level, job level, or step level.

#### Steps
1. **checkout repository onto the runner**
2. **Login to Docker Hub** - uses the `docker/login-action@v2` (again, found in the github marketplace) action to login to your docker hub. It is best practice to hide your credentials so we used Github Action Secrets to store sensitive information 
3. **Build and push** - push the docker image to docker hub. We use a combination of **secrets** variable and the `env` variable to name our docker image


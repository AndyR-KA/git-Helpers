# git-Helpers

## Script how-tos

Run these scripts from a Git working tree in **Command Prompt**. Unless noted otherwise, start in the repository root. They are Windows batch files and require the command-line tools used by the particular script.

### `cirun.BAT`

Queues a GitHub Actions workflow for the current branch and opens the newest matching run in Microsoft Edge. The workflow defaults to `ci.yml`; pass a different workflow name without the `.yml` extension to select another workflow.

- **Requirements:** Git, GitHub CLI (`gh`) authenticated with permission to run the workflow, the `GITHUB_ORG` environment variable set to the repository's GitHub organization, and Microsoft Edge. Run it from a path where the script can infer the repository name from the current directory.
- **Usage:** `..\Batch\cirun.BAT [workflow-name]`
- **Examples:** `..\Batch\cirun.BAT` runs `ci.yml`; `..\Batch\cirun.BAT release` runs `release.yml`.
- **Cautions:** The script derives the repository name from the current path and combines it with `GITHUB_ORG`; check both values before running. It waits 10 seconds before looking up the latest run, so the browser may not open the newly queued run immediately if GitHub has not listed it yet.

### `cmain.BAT`

Checks out `main` and pulls its latest changes. If a branch name is supplied, it then checks out that branch, creating it from the updated `main` if it does not already exist. Existing branches are checked out and pulled.

- **Requirements:** Git, a `main` branch, and a working remote/upstream configuration for the pulls.
- **Usage:** `..\Batch\cmain.BAT [branch-name]`
- **Examples:** `..\Batch\cmain.BAT` updates and leaves you on `main`; `..\Batch\cmain.BAT feature/my-change` updates `main` and switches to or creates `feature/my-change`.
- **Cautions:** The script changes the checked-out branch and may update local branches from their remotes. Commit or stash work that should not be carried across a branch switch.

### `mmain.BAT`

Updates local `main`, returns to the branch that was checked out when the script started, and merges `main` into that branch with the default merge message.

- **Requirements:** Git, a `main` branch, and a working remote/upstream configuration for `git pull`.
- **Usage:** `..\Batch\dhrc.BAT`
- **Example:** Run `..\Batch\dhrc.BAT` from the feature branch you want to update with `main`.
- **Cautions:** This performs a merge and can produce merge conflicts. Resolve them on the current feature branch; the script does not check whether earlier checkout or pull commands failed before continuing.

### `dhrc.BAT`

Runs an Azure DevOps pipeline for the current branch and opens its build-results page. The pipeline ID defaults to `136`.

- **Requirements:** Git, Azure CLI with the Azure DevOps extension, an authenticated Azure DevOps session with permission to queue the pipeline, PowerShell for parsing the CLI's JSON output, and access to the `darkhorse` project in the `badhorse` organization.
- **Usage:** `..\Batch\mmain.BAT [pipeline-id]`
- **Examples:** `..\Batch\mmain.BAT` runs pipeline `136`; `..\Batch\mmain.BAT 42` runs pipeline `42`.
- **Cautions:** The script writes `pipeline_result.json` in the current directory while it runs, then deletes it on success. A pre-existing file with that name can be overwritten. The results link is fixed to the `badhorse/Darkhorse` Azure DevOps project.

### `rebase-to-new-head.BAT`

Creates a new branch at a specified commit, tag, or branch, then cherry-picks onto it—in oldest-first order—the commits reachable from a source branch that are not already reachable from the new base. It does not perform a Git `rebase` command.

- **Requirements:** Git and a working tree that can switch to a new branch and apply the commits without unrelated uncommitted changes. The source branch and new base must exist, and the target branch name must not already exist locally.
- **Usage:** `..\Batch\rebase-to-new-head.BAT`, then enter the source branch, new target branch name, and new base when prompted.
- **Example:** Enter `feature/old`, `feature/new-base`, and `origin/main` to create `feature/new-base` at `origin/main` and cherry-pick the source-only commits onto it.
- **Cautions:** The script leaves you on the newly created target branch; it does not switch back to the original branch. If a cherry-pick conflicts, resolve the conflict and run `git cherry-pick --continue`, or cancel the operation with `git cherry-pick --abort`. The partially created target branch remains until you remove it yourself.

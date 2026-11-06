# Agent P for WebGoat-Legacy

Agent P is onboarded through the GitHub App and Lifecycle. Keep repository policy
settings in Agent P's repository configuration; the workflow gate downloads the
effective `agp.yml`. Do not commit a second `agp.yml` to this repository.

Use `mvn -B --no-transfer-progress clean verify` as the validation command. Keep
Validation Gates enabled. The repository has no automated test sources; this
command checks compilation and packaging but does not establish test coverage.

## Java 8 runtime

This application uses legacy Java APIs that do not compile on the stock Agent P
image's JDK 17/21/25. The workflow builds a local image from the pinned official
Agent P 1.0.0 image and adds Alpine's Java 8 package. It keeps the vendor's non-root
entrypoint. Nothing is published to Docker Hub.

This Java 8 extension is a repository-specific customization, outside Sonatype's
stock-image support guarantee. Recheck it when upgrading the Agent P base image.

## Lifecycle connectivity

The generated configuration uses `http://127.0.0.1:8070` as IQ's canonical base URL.
GitHub-hosted runners cannot use that address to reach IQ on a developer's Mac.
The gate reports this configuration error before attempting authentication.

Choose an execution environment before running:

| Execution environment | Repository Actions variables |
| --- | --- |
| GitHub-hosted runner with reachable HTTPS IQ | Set `AGP_API_URL` to `https://YOUR-IQ-HOST/api/agp` and `AGP_OIDC_AUDIENCE` to IQ's configured canonical base URL. Update IQ/GitHub App URLs consistently when changing that base URL. |
| Separately approved local macOS ARM64 runner | Set `AGP_RUNNER_LABELS` to `["self-hosted","macOS","ARM64","agent-p-webgoat"]`. The existing loopback URL/audience can be retained. The runtime entrypoint maps only the container's transport address to `host.docker.internal`; the audience remains unchanged. |

GitHub recommends private repositories for self-hosted runners. This repository
is public: register a local runner only after explicitly reviewing its access to
the machine and Docker Desktop, preferably in a dedicated isolated environment.
The workflow supports manual and scheduled runs; it does not add PR-triggered
execution. Runner labels route jobs; they do not create a security boundary.

Once connectivity is configured, open **Actions → Sonatype Guide - Agent P →
Run workflow**, or start a run from Agent P. First verify a dry run with the
repository's Dry Run setting enabled. Only disable Dry Run when you want actual
upgrade branches and pull requests. Keep Auto Merge off for human review.

Authentication continues to use GitHub OIDC and the installed GitHub App. No
long-lived IQ/GitHub token needs to be added to this workflow.

References: [Sonatype onboarding](https://help.sonatype.com/en/connect-and-onboard-repositories-1068787.html),
[official Agent P action](https://github.com/sonatype/agp-action),
[GitHub self-hosted runner requirements](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/add-runners).

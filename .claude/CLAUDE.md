# Personal Claude Code Configuration

## Identity
- **Team**: Product Analytics (PANA) at Datadog
- **Username**: pierre.pessarossi

## Repository Context

| Repository | Purpose | Working Directory |
|------------|---------|-------------------|
| `DataDog/data-science` | Exploration & analysis | `pana/` folder |
| `DataDog/dd-analytics` | Production batch jobs / DAG scheduling | - |

## Git Conventions and workflow
Commits shoud be atomic: one change leads to one commit. However a change can include several files if they are related to the same change.
Example: a function refactoring with the related unit tests refactoting.
Commits message should follow the conventional commits convetions.

Before stating a new feature or analysis, you should run without asking permission
`git dd sync`
If you are on `master` or `main` branch, create a new branch following the naming convention below. If not you can assume you are on the expected branch. 

### Branch Naming
Format: `pierre.pessarossi/PANA-<TICKET>/<description>`

- `<TICKET>`: JIRA ticket number (e.g., `1234`) or `NOJIRA` if none exists
- `<description>`: Kebab-case summary derived from ticket title or context

Examples:
- `pierre.pessarossi/PANA-1234-user-retention-analysis`
- `pierre.pessarossi/PANA-NOJIRA-ad-hoc-funnel-exploration`

## Plan Execution
When executing a plan saved as markdown, update progress by checking off completed items (`- [x]`).

## Data Science Explorations

When I request an exploration, follow this workflow:

### 1. Gather Requirements
Before building any plan, ask me for:
1. **Context & Goal**: I may provide a JIRA link, ticket number, or direct description
2. **Output folder name**: Where results will be saved (passed to the agent)
3. **JIRA ticket number**: If not already provided

### 2. Set Up Branch
```bash
git dd sync
git checkout master
git checkout -b pierre.pessarossi/PANA-<TICKET>/<description>
```

### 3. Create Exploration Plan
- Save to: `/Users/pierre.pessarossi/go/src/github/com/DataDog/data-science/pana/<exploration_name>/exploration_plan.md`
- Include: context, goal, and detailed exploration steps
- Use checkboxes for trackable progress

### 4. Execute with Agents
- Use `Task` tool with `subagent_type='ml-exploration-analyst'`
- Launch **one agent per exploration idea**
- Pass each agent: context + relevant steps from the plan
- **Wait for my approval** of the plan before launching agents
- Do not ask for my approval when running the analysis unless the agent as been explicitly specified to do so on some tasks

### 5. Commit Results
Commit code produced by each agent with meaningful commit messages.

# Cadmium Monorepo Justfile
# Run `just` to see all available commands

# List all available commands
_default:
    @just --list --unsorted

# ============================================================================
# Development Setup
# ============================================================================

# Install dependencies using local submodules
[group('dev')]
install:
    SHARDS_OVERRIDE=shard.dev.yml shards install

# Update all submodules to latest
[group('dev')]
update-submodules:
    git submodule update --remote --merge
    @echo "Submodules updated. Don't forget to commit the changes."

# Initialize submodules (if you cloned without --recursive)
[group('dev')]
init-submodules:
    git submodule update --init --recursive

# Show status of all submodules
[group('dev')]
submodule-status:
    git submodule status

# Show which submodules have changed
[group('dev')]
submodule-summary:
    git submodule summary

# ============================================================================
# Running Commands on Individual Shards
# ============================================================================

# Run specs for a specific shard
[group('shard')]
test shard:
    #!/usr/bin/env bash
    set -e
    cd shards/{{ shard }}
    CRYSTAL_PATH="lib:$(cd ../.. && pwd)/lib:$(crystal env CRYSTAL_PATH)" crystal spec

# Run specs for all shards
[group('shard')]
test-all:
    #!/usr/bin/env bash
    for shard in shards/*/; do
        shard_name=$(basename "$shard")
        echo "Testing $shard_name..."
        cd "$shard" && crystal spec && cd ../.. || echo "Failed: $shard_name"
    done

# Format code in a specific shard
[group('shard')]
format shard:
    cd shards/{{ shard }} && crystal tool format --check

# Format and fix code in a specific shard
[group('shard')]
format-fix shard:
    cd shards/{{ shard }} && crystal tool format --fix

# Format all shards
[group('shard')]
format-all:
    #!/usr/bin/env bash
    for shard in shards/*/; do
        shard_name=$(basename "$shard")
        echo "Formatting $shard_name..."
        cd "$shard" && crystal tool format --fix && cd ../..
    done

# Run ameba on a specific shard
[group('shard')]
ameba shard:
    cd shards/{{ shard }} && crystal run ../bin/ameba

# ============================================================================
# Shard Release Management
# ============================================================================

# Create a release branch for a shard
[group('release')]
release-branch shard version:
    #!/usr/bin/env bash
    set -e
    cd shards/{{ shard }}
    echo "Creating release branch for {{ shard }} v{{ version }}..."
    git checkout -b release/v{{ version }}
    cd ../..
    echo "Release branch created. Now:"
    echo "1. Update shard.yml version in shards/{{ shard }}/shard.yml"
    echo "2. Make any other changes"
    echo "3. Run: just commit-shard {{ shard }}"

# Commit changes to a shard (including submodule update)
[group('release')]
commit-shard shard message='Update shard':
    #!/usr/bin/env bash
    set -e
    cd shards/{{ shard }}
    echo "Committing changes to {{ shard }}..."
    git add .
    git commit -m "{{ message }}"
    echo "Changes committed to {{ shard }} submodule"
    echo "Now run: just update-submodule-ref {{ shard }}"

# Update the parent repo's reference to a shard
[group('release')]
update-submodule-ref shard message:
    #!/usr/bin/env bash
    set -e
    cd ../..
    echo "Updating parent repo reference to {{ shard }}..."
    git add shards/{{ shard }}
    git commit -m "{{ message }}"
    echo "Submodule reference updated in parent repo"

# Tag and push a shard release
[group('release')]
tag-shard shard version:
    #!/usr/bin/env bash
    set -e
    cd shards/{{ shard }}
    echo "Tagging {{ shard }} v{{ version }}..."
    git tag -a "v{{ version }}" -m "Release v{{ version }}"
    git push origin "v{{ version }}"
    echo "Tag pushed to {{ shard }} repository"
    cd ../..
    echo "Don't forget to:"
    echo "1. Update the version in the main shard.yml if needed"
    echo "2. Create a GitHub release"

# Full release workflow: commit, tag, and push a shard
[group('release')]
release shard version message:
    #!/usr/bin/env bash
    set -e
    echo "Starting release of {{ shard }} v{{ version }}..."
    just commit-shard {{ shard }} "{{ message }}"
    just update-submodule-ref {{ shard }} "Update {{ shard }} for v{{ version }}"
    just tag-shard {{ shard }} {{ version }}
    echo "Release complete!"

# ============================================================================
# Git Operations
# ============================================================================

# Clone a new shard repository into shards/
[group('git')]
add-shard repo name:
    #!/usr/bin/env bash
    set -e
    if [ ! -d "shards/{{ name }}" ]; then
        git submodule add "https://github.com/{{ repo }}.git" "shards/{{ name }}"
        echo "Added {{ name }} as a submodule"
        echo "Run 'git commit -m \"Add {{ name }} submodule\"' to commit"
    else
        echo "Error: shards/{{ name }} already exists"
        exit 1
    fi

# Remove a shard submodule
[group('git')]
remove-shard name:
    #!/usr/bin/env bash
    set -e
    if [ -d "shards/{{ name }}" ]; then
        git submodule deinit -f shards/{{ name }}
        git rm -f shards/{{ name }}
        rm -rf .git/modules/shards/{{ name }}
        echo "Removed {{ name }} submodule"
        echo "Run 'git commit -m \"Remove {{ name }} submodule\"' to commit"
    else
        echo "Error: shards/{{ name }} does not exist"
        exit 1
    fi

# Push all submodule changes
[group('git')]
push-submodules:
    #!/usr/bin/env bash
    for shard in shards/*/; do
        shard_name=$(basename "$shard")
        echo "Pushing $shard_name..."
        cd "$shard" && git push && cd ../.. || echo "No changes or failed: $shard_name"
    done

# ============================================================================
# Utility Commands
# ============================================================================

# Clean build artifacts
[group('util')]
clean:
    rm -rf .shards lib bin

# Show repository structure
[group('util')]
ls-shards:
    #!/usr/bin/env bash
    echo "Cadmium shards:"
    for shard in shards/*/; do
        name=$(basename "$shard")
        if [ -d "$shard/.git" ]; then
            cd "$shard"
            branch=$(git branch --show-current)
            commit=$(git rev-parse --short HEAD)
            cd ../..
            echo "  - $name (branch: $branch, commit: $commit)"
        fi
    done

# Check for uncommitted changes in submodules
[group('util')]
submodule-diff:
    #!/usr/bin/env bash
    for shard in shards/*/; do
        shard_name=$(basename "$shard")
        cd "$shard"
        if ! git diff --quiet || ! git diff --cached --quiet; then
            echo "Uncommitted changes in $shard_name:"
            git status --short
        fi
        cd ../..
    done

# Open a shard in your editor (set $EDITOR)
[group('util')]
edit shard:
    #!/usr/bin/env bash
    if [ -z "$EDITOR" ]; then
        echo "Error: \$EDITOR environment variable not set"
        echo "Set it in your shell config, e.g.: export EDITOR=vim"
        exit 1
    fi
    cd shards/{{ shard }} && exec $EDITOR .

# Show help for a specific recipe category
[group('help')]
help category:
    #!/usr/bin/env bash
    echo "Recipes in category '{{ category }}':"
    just --list {{ category }}

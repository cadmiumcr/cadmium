# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Cadmium** is a Natural Language Processing (NLP) library for Crystal, organized as a monorepo using git submodules. Each NLP component is a separate shard with its own git repository, versioning, and release cycle.

## Development Setup

### Initial Setup
```bash
git clone --recursive git@github.com:cadmiumcr/cadmium.git
cd cadmium
SHARDS_OVERRIDE=shard.dev.yml shards install
```

**Critical:** Always use `SHARDS_OVERRIDE=shard.dev.yml` when running `shards install` for development. This uses local path dependencies instead of GitHub dependencies.

### If Already Cloned Without --recursive
```bash
git submodule update --init --recursive
SHARDS_OVERRIDE=shard.dev.yml shards install
```

## Common Commands (via justfile)

Install [just](https://github.com/casey/just) if needed. Run `just` to see all commands.

### Development
```bash
just install              # Install dependencies (uses shard.dev.yml)
just update-submodules    # Update all submodules to latest
just submodule-status     # Check submodule status
```

### Testing
```bash
just test <shard>         # Run tests for specific shard (e.g., just test cadmium_tokenizer)
just test-all             # Run tests for all shards
```

### Code Quality
```bash
just format-fix <shard>   # Format code in a shard
just format-all           # Format all shards
just ameba <shard>        # Run linter on a shard
```

### Release Management
```bash
just release <shard> <version> "<message>"  # Full release workflow
just release-branch <shard> <version>       # Create release branch
just commit-shard <shard> "<message>"       # Commit changes to shard
just tag-shard <shard> <version>            # Tag and push release
```

### Git Operations
```bash
just add-shard <repo> <name>     # Add new submodule (e.g., just add-shard cadmiumcr/stemmer cadmium_stemmer)
just remove-shard <name>          # Remove submodule
just push-submodules              # Push all submodule changes
```

## Architecture

### Monorepo Structure
- `shards/` - Git submodules, each a separate Cadmium shard
- `lib/` - Symlinks to shard directories (legacy)
- `shard.yml` - Production dependencies (GitHub)
- `shard.dev.yml` - Development dependencies (local paths)

### Shard Components

**Text Processing:**
- `cadmium_tokenizer` - String tokenization
- `cadmium_stemmer` - Porter stemmer
- `cadmium_lemmatizer` - Word lemmatization (depends on: cadmium_pos_tagger)
- `cadmium_inflector` - English word inflection

**Analysis:**
- `cadmium_pos_tagger` - Part-of-speech tagging
- `cadmium_sentiment` - Sentiment analysis
- `cadmium_readability` - Text readability
- `cadmium_summarizer` - Text summarization (depends on: cadmium_lemmatizer, cadmium_stemmer)
- `cadmium_language_detector` - Language detection

**Math/Data Structures:**
- `cadmium_ngrams` - N-gram extraction
- `cadmium_tfidf` - TF-IDF calculation
- `cadmium_distance` - String distance algorithms
- `cadmium_graph` - Edge-weighted digraph
- `cadmium_trie` - Trie data structure
- `cadmium_classifier` - Probabilistic classifiers
- `cadmium_glove` - Word embeddings

**Utilities:**
- `cadmium_phonetics` - Phonetic matching
- `cadmium_transliterator` - UTF-8 to ASCII
- `cadmium_wordnet` - WordNet lexical database
- `cadmium_util` - Internal utilities

### Working with Submodules

Each shard is a separate git repository. To make changes:

1. Navigate to the shard: `cd shards/cadmium_<name>`
2. Create a branch: `git checkout -b feature/my-changes`
3. Commit and push to the shard's repository
4. Return to parent repo and update submodule reference: `git add shards/cadmium_<name>`

**Important:** Always commit changes within the submodule first, then update the parent repo's submodule reference.

## Dependency Management

### Internal Dependencies
Some shards depend on others:
- `cadmium_summarizer` → `cadmium_lemmatizer` → `cadmium_pos_tagger`
- `cadmium_language_detector` → `cadmium_classifier`

When modifying a shard that others depend on, consider the impact on dependent shards.

### External Dependencies
- `apatite` - Matrix operations (used by summarizer)
- `ameba` - Linter (dev dependency in each shard)

## Release Workflow

1. Create release branch: `just release-branch <shard> <version>`
2. Update version in `shards/<shard>/shard.yml`
3. Commit changes: `just commit-shard <shard> "<message>"`
4. Update parent repo reference: `just update-submodule-ref <shard> "<message>"`
5. Tag and push: `just tag-shard <shard> <version>`

Or use the full workflow: `just release <shard> <version> "<message>"`

## Testing

Each shard has its own `spec/` directory. Run tests from the monorepo root using `just test <shard>`, or navigate to individual shards and run `crystal spec`.

## Troubleshooting

**Detached HEAD in submodule:**
```bash
cd shards/<shard>
git checkout -b my-feature-branch
```

**Submodule not initialized:**
```bash
git submodule init
git submodule update
```

**Dependencies not resolving correctly:**
Ensure you're using `SHARDS_OVERRIDE=shard.dev.yml shards install` for development.

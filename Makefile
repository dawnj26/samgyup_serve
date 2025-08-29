# Find all package directories (having a pubspec.yaml) inside packages/
PACKAGE_PUBS := $(shell [ -d packages ] && find packages -mindepth 2 -maxdepth 2 -name pubspec.yaml 2>/dev/null | sort || true)
PACKAGES := $(PACKAGE_PUBS:%/pubspec.yaml=%)

# Determine which packages (and root) use build_runner
ROOT_HAS_BUILD_RUNNER := $(shell grep -E '^[[:space:]]*[^#].*build_runner:' pubspec.yaml >/dev/null 2>&1 && echo 1 || echo 0)
BUILD_RUNNER_PACKAGES := $(shell for p in $(PACKAGES); do grep -E '^[[:space:]]*[^#].*build_runner:' $$p/pubspec.yaml >/dev/null 2>&1 && echo $$p; done)

# Tool executables
FLUTTER ?= flutter
DART ?= dart

# Public targets
.PHONY: help deps update update-major generate generate-only release-prod release-stg
# Private targets
.PHONY: _deps_root _deps_packages _update_root _update_packages _update_major_root _update_major_packages _gen_root _gen_packages

#
# Public Commands
#

help:
	@echo "Targets:"
	@echo "  deps         - Run 'flutter pub get' in root and all packages"
	@echo "  update       - Run 'flutter pub upgrade' in root and all packages"
	@echo "  update-major - Run 'flutter pub upgrade --major-versions' in root and all packages"
	@echo "  generate     - Run build_runner build in root (if needed) and in packages needing it"
	@echo "  generate-only - Run build_runner build without fetching dependencies first"
	@echo "  release-prod - Generate code and build production APK with ABI splits"
	@echo "  release-stg  - Generate code and build staging APK with ABI splits"
	@echo ""
	@echo "Variables:"
	@echo "  FLUTTER=<flutter executable> (default: flutter)"
	@echo "  DART=<dart executable> (default: dart)"

# Dependency management
deps: _deps_root _deps_packages

update: _update_packages _update_root

update-major: _update_major_packages _update_major_root

# Code generation
generate: deps _gen_root _gen_packages

generate-only: _gen_root _gen_packages

# Release builds
release-prod: generate
	@echo "==> Building production APK"
	@$(FLUTTER) build apk --flavor production --split-per-abi -t lib/main_production.dart

release-stg: generate
	@echo "==> Building staging APK"
	@$(FLUTTER) build apk --flavor staging --split-per-abi -t lib/main_staging.dart

#
# Private Commands
#

# Dependencies
_deps_root:
	@echo "==> Getting dependencies (root)"
	@$(FLUTTER) pub get

_deps_packages:
ifneq ($(PACKAGES),)
	@echo "==> Getting dependencies (packages)"
	@set -e; for p in $(PACKAGES); do \
		echo "--> $$p"; \
		( cd $$p && $(FLUTTER) pub get ); \
	done
else
	@echo "No packages/ subpackages detected."
endif

# Updates
_update_root:
	@echo "==> Updating dependencies (root)"
	@$(FLUTTER) pub upgrade

_update_packages:
ifneq ($(PACKAGES),)
	@echo "==> Updating dependencies (packages)"
	@set -e; for p in $(PACKAGES); do \
		echo "--> $$p"; \
		( cd $$p && $(FLUTTER) pub upgrade ); \
	done
else
	@echo "No packages/ subpackages detected."
endif

_update_major_root:
	@echo "==> Updating dependencies with major versions (root)"
	@$(FLUTTER) pub upgrade --major-versions

_update_major_packages:
ifneq ($(PACKAGES),)
	@echo "==> Updating dependencies with major versions (packages)"
	@set -e; for p in $(PACKAGES); do \
		echo "--> $$p"; \
		( cd $$p && $(FLUTTER) pub upgrade --major-versions ); \
	done
else
	@echo "No packages/ subpackages detected."
endif

# Code generation
_gen_root:
ifneq ($(ROOT_HAS_BUILD_RUNNER),0)
	@echo "==> build_runner (root)"
	@$(DART) run build_runner build --delete-conflicting-outputs
else
	@echo "Root does not depend on build_runner (skipping)."
endif

_gen_packages:
ifneq ($(BUILD_RUNNER_PACKAGES),)
	@echo "==> build_runner (packages)"
	@set -e; for p in $(BUILD_RUNNER_PACKAGES); do \
		echo "--> $$p"; \
		( cd $$p && $(DART) run build_runner build --delete-conflicting-outputs ); \
	done
else
	@echo "No packages with build_runner dependency found."
endif

# Find all package directories (having a pubspec.yaml) inside packages/
PACKAGE_PUBS := $(shell [ -d packages ] && find packages -mindepth 2 -maxdepth 2 -name pubspec.yaml 2>/dev/null | sort || true)
PACKAGES := $(PACKAGE_PUBS:%/pubspec.yaml=%)

# Determine which packages (and root) use build_runner
ROOT_HAS_BUILD_RUNNER := $(shell grep -E '^[[:space:]]*[^#].*build_runner:' pubspec.yaml >/dev/null 2>&1 && echo 1 || echo 0)
BUILD_RUNNER_PACKAGES := $(shell for p in $(PACKAGES); do grep -E '^[[:space:]]*[^#].*build_runner:' $$p/pubspec.yaml >/dev/null 2>&1 && echo $$p; done)

DART ?= dart

.PHONY: help deps generate _deps_root _deps_packages _gen_root _gen_packages

help:
	@echo "Targets:"
	@echo "  deps      - Run 'dart pub get' in root and all packages"
	@echo "  generate  - Run build_runner build in root (if needed) and in packages needing it"
	@echo ""
	@echo "Variables:"
	@echo "  DART=<dart executable> (default: dart)"

deps: _deps_root _deps_packages

_deps_root:
	@echo "==> Getting dependencies (root)"
	@$(DART) pub get

_deps_packages:
ifneq ($(PACKAGES),)
	@echo "==> Getting dependencies (packages)"
	@set -e; for p in $(PACKAGES); do \
		echo "--> $$p"; \
		( cd $$p && $(DART) pub get ); \
	done
else
	@echo "No packages/ subpackages detected."
endif

generate: deps _gen_root _gen_packages

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

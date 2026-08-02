.PHONY: check fmt lint rebuild-jade rebuild-cobble rebuild-heimdall build-jade build-cobble build-heimdall vm-jade help

check:
	nix flake check

fmt:
	nix fmt

lint:
	nix flake check --verbose

rebuild-jade:
	sudo nixos-rebuild switch --flake .#jade

rebuild-cobble:
	sudo nixos-rebuild switch --flake .#cobble

rebuild-heimdall:
	sudo nixos-rebuild switch --flake .#heimdall

build-jade:
	nixos-rebuild build --flake .#jade

build-cobble:
	nixos-rebuild build --flake .#cobble

build-heimdall:
	nixos-rebuild build --flake .#heimdall

vm-jade:
	nixos-rebuild build-vm --flake .#jade && ./result/bin/run-jade-vm

help:
	@echo "Cibles disponibles :"
	@echo "  make check             - nix flake check"
	@echo "  make fmt               - formate le code Nix (nixfmt)"
	@echo "  make rebuild-jade      - rebuild switch de Jade"
	@echo "  make rebuild-cobble    - rebuild switch de Cobble"
	@echo "  make rebuild-heimdall  - rebuild switch de Heimdall"
	@echo "  make build-<host>      - build sans appliquer"
	@echo "  make vm-jade           - build + lance une VM de test de Jade"

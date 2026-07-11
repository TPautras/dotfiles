.PHONY: check fmt lint rebuild-jade rebuild-cobble build-jade build-cobble vm-jade help

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

build-jade:
	nixos-rebuild build --flake .#jade

build-cobble:
	nixos-rebuild build --flake .#cobble

vm-jade:
	nixos-rebuild build-vm --flake .#jade && ./result/bin/run-jade-vm

help:
	@echo "Cibles disponibles :"
	@echo "  make check          - nix flake check"
	@echo "  make fmt            - formate le code Nix (nixfmt)"
	@echo "  make rebuild-jade   - rebuild switch de Jade"
	@echo "  make rebuild-cobble - rebuild switch de Cobble"
	@echo "  make build-jade     - build Jade sans appliquer"
	@echo "  make build-cobble   - build Cobble sans appliquer"
	@echo "  make vm-jade        - build + lance une VM de test de Jade"

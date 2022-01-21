all: lint

lint:
	npx prettier \
		--ignore-path '.github/lint/.prettierignore' \
		--config '.github/lint/.prettierrc.yaml' \
		--list-different \
		--ignore-unknown \
		--parser=yaml \
		--write '**/*.yml' '**/*.yaml'

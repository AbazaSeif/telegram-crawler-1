start:
	docker-compose up -d

rebuild:
	docker-compose up -d --no-deps --build $(service)

test:
	docker-compose exec console phpunit $(path) ||:

php:
	docker-compose exec php bash

logs:
	tail -f storage/logs/laravel.log
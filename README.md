# AW-API

A simple ROR API with custom jwt authentication, policies for authorization and CRUD operations for the user's contents.

## Setup

### Prerequisites

- Ruby 3.0+

## Usage Instructions

- Clone or download the repo.
- `bundle install`
- `rails db:create`
- `rails db:migrate`
- `rails server`

## For Docker

- `cp .env.example .env`
- Replace the required values with your credentials
- `docker compose -f docker-compose.yml up -d`

## Important

- Rails master key can't be shared in public repo. Will be shared upon requests.

## Running Specs

- `bundle exec rspec`

## Testing Specs

### Postman

- Here's the collection that can be used: `https://strivereep-8996279.postman.co/workspace/5dab54e9-03d4-4fef-8949-38d152797a6b/collection/50818615-4f10a2fb-ca32-4bd5-9999-30bd95e37702?action=share&source=copy-link&creator=50818615`

- Add ENVIORNMENT variables before running the endpoints.
- List of ENV variables:

  - SCHEME: `http or https`
  - SERVER: `server host, for e.g. localhost:3000/api`
  - VERSION: `v1 or v2`
  - VALID_TOKEN: Valid JWT token
  - NOT_AUTHORIZED_TOKEN: Valid JWT token but of different user

### Swagger

- You can simply run the server and visit: `/api-docs`

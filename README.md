# 🐾 Pet Tracker API

[![CI](https://github.com/ibalosh/pet_tracker/actions/workflows/ci.yml/badge.svg)](https://github.com/ibalosh/pet_tracker/actions/workflows/ci.yml)

Ruby on Rails API-only app that tracks pets using various types of trackers and reports how many are currently outside the 
power saving zone grouped by pet type and tracker type. The system supports both data ingestion and querying via a REST API.

## Getting Started

### Requirements
- Ruby version in `.ruby-version` file 
- Rails 7+
- Bundler
- SQLite (in-memory, no setup needed)

### Setup

1. Clone the repository 
2. Execute the below commands, in root folder of the Rails app, to install gem, loads the schema and seeds example data

```bash
bundle install
bin/rails db:setup
```

Once the setup is complete, you can start the Rails server:

```bash
bin/rails server
```

`db/seeds.rb` creates a few example records for testing purposes.

## Running Tests

To run the test suite, execute the following command in the root folder

```bash
bundle exec rspec
```

## API Notes

Detailed API usage and endpoints are documented in [API_REFERENCE.md](API_REFERENCE.md)

### Design Notes

- Normalized db schema
- In-memory SQLite for easy testing & setup & swapping
- API endpoints for data ingestion and querying, with pagination
  - in order to paginate use `?page=X` query parameter

#### Assumptions

- `in_zone` is **not calculated dynamically**, but a stored boolean field in the `trackers` table
- The `lost_tracker` attribute:
    - Is only valid for **cats**
    - Enforced via a model validation on trackers
    - if tracker is lost, we don't count that entry containing it in in_zone=true/false calculation since we can't know whether Pet is in zone
- The `tracker_type` can only have one type of category per species:
  - category `small` can be created only once for `dog`
- The `/tracker_summaries` endpoint applies filters as follows:
    - If the `in_zone` filter is **not provided**, it's used by default value `false`
    - Only **trackers with `lost_tracker: false`** are included in the summary
    - Filtering by `pet_type` (e.g. `"Dog"` or `"Cat"`) and `tracker_type` (e.g. `"small"`, `"medium"`) is optional
    - If no filters are provided, all trackers are included in the summary
- The summary data is grouped by:
    - `species_id` (i.e. pet type)
    - `tracker_type_id` (i.e. tracker type)
- Pet can have multiple trackers

### Postman Collection

A Postman collection with all requests is included in the repo as `postman_collection.json` in **docs** folder.

### Quick API Demo with `curl`

You can use the following `curl` commands to manually create and retrieve data, verifying the main 
functionality without relying on seed data.

### 1. Create Species

```bash
curl -X POST http://localhost:3000/species \
  -H "Content-Type: application/json" \
  -d '{"name": "Cat"}'

curl -X POST http://localhost:3000/species \
  -H "Content-Type: application/json" \
  -d '{"name": "Dog"}'
```
### 2. Create Tracker Types

```bash
curl -X POST http://localhost:3000/tracker_types \
  -H "Content-Type: application/json" \
  -d '{"category": "medium", "species_id": 1}'
```
### 3. Create Owners and Pets

```bash
curl -X POST http://localhost:3000/owners \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice", "email": "alice@example.com"}'

curl -X POST http://localhost:3000/pets \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Whiskers",
    "owner_id": 1,
    "species_id": 1
  }'
```

### 4. Create Trackers and Trackers Summaries

With no filter set, `in_zone` filter will be set to false.

```bash
curl -X POST http://localhost:3000/trackers \
  -H "Content-Type: application/json" \
  -d '{
    "pet_id": 1,
    "tracker_type_id": 1,
    "in_zone": false
  }'

curl -X GET "http://localhost:3000/tracker_summaries"
curl -X GET "http://localhost:3000/tracker_summaries?in_zone=false&pet_type=Cat&tracker_type=medium"
```
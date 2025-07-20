# 🐾 Pet Tracker API

[![CI](https://github.com/ibalosh/pet_tracker/actions/workflows/ci.yml/badge.svg)](https://github.com/ibalosh/pet_tracker/actions/workflows/ci.yml)

This is a Ruby on Rails API-only application that tracks pets (dogs and cats) using various types of trackers and reports how many 
are currently outside the power saving zone grouped by pet type and tracker type. The system supports both data ingestion and querying 
via a REST API.

## 🚀 Getting Started

### Requirements
- Ruby 3.3.3
- Rails 7+
- Bundler
- SQLite (in-memory, no setup needed)

### Setup

Clone the repository first and in root folder run:

```bash
bundle install
bin/rails db:setup
```

> ✅ `db:setup` loads the schema and seeds example data.

---

## 🧪 Running Tests

```bash
bundle exec rspec
```

## 🌱 Seeded Data

`db/seeds.rb` creates:

- Species 
- Tracker Types
- Trackers 
- Owners and Pets

---

## 📬 API Reference

Detailed API usage and endpoints are documented in [API_REFERENCE.md](API_REFERENCE.md)

## 🛠 Design Notes

- Normalized db schema
- In-memory SQLite for easy testing & setup
- Ready to swap database backend
- Clean controllers, pagination extracted

---

## 🗂 Postman Collection

A Postman collection with all requests is included in the repo as `postman_collection.json` in docs folder.

## 🐾 Quick API Demo with `curl`

You can use the following `curl` commands to manually create and retrieve data, verifying the main functionality without relying on seed data.

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
    "species_id": 1,
    "lost_tracker": false
  }'
```

### 4. Create Trackers and Trackers Summaries

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
# 📚 API Reference

All data is exchanged as JSON.

---

## Owners

| Method | Endpoint           | Description                     |
|--------|--------------------|---------------------------------|
| GET    | `/owners`          | List owners with pagination     |
| GET    | `/owners/:id`      | Fetch single owner              |
| POST   | `/owners`          | Create owner                    |
| PATCH  | `/owners/:id`      | Update owner                    |
| DELETE | `/owners/:id`      | Delete owner                    |

---

## Species

| Method | Endpoint       | Description          |
|--------|----------------|----------------------|
| GET    | `/species`     | List species         |
| GET    | `/species/:id` | Fetch single species |
| POST   | `/species`     | Create species       |
| PATCH  | `/species/:id` | Update species       |
| DELETE | `/species/:id` | Delete species       |

---

## Tracker Types

| Method | Endpoint               | Description                              |
|--------|------------------------|------------------------------------------|
| GET    | `/tracker_types`       | List tracker types                       |
| GET    | `/tracker_types/:id`   | Fetch single tracker_types               |
| POST   | `/tracker_types`       | Create tracker type (unique per species) |
| PATCH  | `/tracker_types/:id`   | Update tracker_type                      |
| DELETE | `/tracker_types/:id`   | Delete tracker_type                      |
---

## Pets

| Method | Endpoint        | Description                          |
|--------|-----------------|--------------------------------------|
| GET    | `/pets`         | List pets with pagination            |
| GET    | `/pets/:id`     | Fetch single pet                     |
| POST   | `/pets`         | Create pet (requires species/owner)  |
| PATCH  | `/pets/:id`     | Update pet                           |
| DELETE | `/pets/:id`     | Delete pet                           |

> 🐱 Cats support `lost_tracker: true/false`.

---

## Trackers

| Method | Endpoint        | Description                        |
|--------|-----------------|------------------------------------|
| GET    | `/trackers`     | List pets with pagination          |
| GET    | `/trackers/:id` | Fetch single tracker               |
| POST   | `/trackers`     | Attach tracker to pet              |
| PATCH  | `/trackers/:id` | Update tracker zone status         |
| DELETE | `/trackers/:id` | Remove tracker                     |

---

## Tracker Summaries

| Method | Endpoint             | Description                                                   |
|--------|----------------------|---------------------------------------------------------------|
| GET    | `/tracker_summaries` | Returns count of pets outside zone, grouped by tracker/species |

### Query Parameters:

- `in_zone=true/false`
- `pet_type=Dog|Cat`
- `tracker_type=small|medium|large`

#### Example

```bash
curl "http://localhost:3000/tracker_summaries?in_zone=false&pet_type=Dog"
```

-- name: GetStorageLocation :one
SELECT * FROM storage_locations
WHERE id = $1 LIMIT 1;

-- name: GetStorageLocationByName :one
SELECT * FROM storage_locations
WHERE name = $1 LIMIT 1;

-- name: ListStorageLocations :many
SELECT * FROM storage_locations
ORDER BY id;

-- name: ListActiveStorageLocations :many
SELECT * FROM storage_locations
WHERE is_active = true
ORDER BY id;

-- name: ListStorageLocationsByType :many
SELECT * FROM storage_locations
WHERE type = $1
ORDER BY id;

-- name: CreateStorageLocation :one
INSERT INTO storage_locations (
    name,
    type,
    config,
    is_active
) VALUES (
    $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateStorageLocation :one
UPDATE storage_locations
SET name = $2,
    type = $3,
    config = $4,
    is_active = $5
WHERE id = $1
RETURNING *;

-- name: ToggleStorageLocationActive :one
UPDATE storage_locations
SET is_active = NOT is_active
WHERE id = $1
RETURNING *;

-- name: DeleteStorageLocation :exec
DELETE FROM storage_locations
WHERE id = $1;
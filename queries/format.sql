-- name: GetFormat :one
SELECT * FROM format
WHERE id = $1 LIMIT 1;

-- name: GetFormatByCodec :one
SELECT * FROM format
WHERE codec = $1 LIMIT 1;

-- name: ListFormats :many
SELECT * FROM format
ORDER BY id;

-- name: CreateFormat :one
INSERT INTO format (
    codec
) VALUES (
    $1
)
RETURNING *;

-- name: UpdateFormat :one
UPDATE format
SET codec = $2
WHERE id = $1
RETURNING *;

-- name: DeleteFormat :exec
DELETE FROM format
WHERE id = $1;
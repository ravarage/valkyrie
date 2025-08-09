-- name: GetCodec :one
SELECT * FROM codec
WHERE id = $1 LIMIT 1;

-- name: GetCodecByName :one
SELECT * FROM codec
WHERE name = $1 LIMIT 1;

-- name: ListCodecs :many
SELECT * FROM codec
ORDER BY name;

-- name: CreateCodec :one
INSERT INTO codec (
    name
) VALUES (
    $1
)
RETURNING *;

-- name: UpdateCodec :one
UPDATE codec
SET name = $2
WHERE id = $1
RETURNING *;

-- name: DeleteCodec :exec
DELETE FROM codec
WHERE id = $1;
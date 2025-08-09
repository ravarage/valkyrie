-- name: GetTType :one
SELECT * FROM t_types
WHERE id = $1 LIMIT 1;

-- name: GetTTypeByKey :one
SELECT * FROM t_types
WHERE type_key = $1 LIMIT 1;

-- name: ListTTypes :many
SELECT * FROM t_types
ORDER BY id;

-- name: CreateTType :one
INSERT INTO t_types (
    type_key,
    name,
    description
) VALUES (
    $1, $2, $3
)
RETURNING *;

-- name: UpdateTType :one
UPDATE t_types
SET type_key = $2,
    name = $3,
    description = $4
WHERE id = $1
RETURNING *;

-- name: DeleteTType :exec
DELETE FROM t_types
WHERE id = $1;
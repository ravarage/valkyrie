-- name: GetFolderAttribute :one
SELECT * FROM folder_attributes
WHERE id = $1 LIMIT 1;

-- name: GetFolderAttributeByFolderID :one
SELECT * FROM folder_attributes
WHERE folder_id = $1 LIMIT 1;

-- name: ListFolderAttributes :many
SELECT * FROM folder_attributes
ORDER BY id;

-- name: CreateFolderAttribute :one
INSERT INTO folder_attributes (
    folder_id,
    detail
) VALUES (
    $1, $2
)
RETURNING *;

-- name: UpdateFolderAttribute :one
UPDATE folder_attributes
SET detail = $2
WHERE id = $1
RETURNING *;

-- name: UpdateFolderAttributeByFolderID :one
UPDATE folder_attributes
SET detail = $2
WHERE folder_id = $1
RETURNING *;

-- name: DeleteFolderAttribute :exec
DELETE FROM folder_attributes
WHERE id = $1;

-- name: DeleteFolderAttributeByFolderID :exec
DELETE FROM folder_attributes
WHERE folder_id = $1;
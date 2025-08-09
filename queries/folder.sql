-- name: GetFolder :one
SELECT * FROM folder
WHERE id = $1 LIMIT 1;

-- name: ListFolders :many
SELECT * FROM folder
ORDER BY id;

-- name: CreateFolder :one
INSERT INTO folder (
    folder
) VALUES (
    $1
)
RETURNING *;

-- name: UpdateFolder :one
UPDATE folder
SET folder = $2
WHERE id = $1
RETURNING *;

-- name: DeleteFolder :exec
DELETE FROM folder
WHERE id = $1;

-- name: GetFolderWithAttributes :one
SELECT f.*, fa.detail
FROM folder f
LEFT JOIN folder_attributes fa ON f.id = fa.folder_id
WHERE f.id = $1
LIMIT 1;

-- name: GetFolderPermissionsByFolderId :many
SELECT * FROM folder_permissions
WHERE folder_id = $1
ORDER BY id;
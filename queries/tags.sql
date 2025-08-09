-- name: GetTag :one
SELECT * FROM tags
WHERE id = $1 LIMIT 1;

-- name: GetTagByName :one
SELECT * FROM tags
WHERE name = $1 LIMIT 1;

-- name: ListTags :many
SELECT * FROM tags
ORDER BY name;

-- name: ListTagsByCreator :many
SELECT * FROM tags
WHERE created_by = $1
ORDER BY name;

-- name: CreateTag :one
INSERT INTO tags (
    name,
    color,
    description,
    created_by
) VALUES (
    $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateTag :one
UPDATE tags
SET name = $2,
    color = $3,
    description = $4
WHERE id = $1
RETURNING *;

-- name: DeleteTag :exec
DELETE FROM tags
WHERE id = $1;

-- name: AddFileTag :exec
INSERT INTO file_tags (
    file_id,
    tag_id
) VALUES (
    $1, $2
);

-- name: RemoveFileTag :exec
DELETE FROM file_tags
WHERE file_id = $1 AND tag_id = $2;

-- name: ListTagsForFile :many
SELECT t.*
FROM tags t
JOIN file_tags ft ON t.id = ft.tag_id
WHERE ft.file_id = $1
ORDER BY t.name;
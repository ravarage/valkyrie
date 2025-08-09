-- name: GetCategory :one
SELECT * FROM categories
WHERE id = $1 LIMIT 1;

-- name: GetCategoryByKey :one
SELECT * FROM categories
WHERE cat_key = $1 LIMIT 1;

-- name: ListCategories :many
SELECT * FROM categories
ORDER BY id;

-- name: ListCategoriesByType :many
SELECT * FROM categories
WHERE t_type_id = $1
ORDER BY id;

-- name: ListSubcategories :many
SELECT * FROM categories
WHERE category_id = $1
ORDER BY id;

-- name: CreateCategory :one
INSERT INTO categories (
    cat_key,
    name,
    description,
    t_type_id,
    category_id
) VALUES (
    $1, $2, $3, $4, $5
)
RETURNING *;

-- name: UpdateCategory :one
UPDATE categories
SET cat_key = $2,
    name = $3,
    description = $4,
    t_type_id = $5,
    category_id = $6
WHERE id = $1
RETURNING *;

-- name: DeleteCategory :exec
DELETE FROM categories
WHERE id = $1;
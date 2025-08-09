-- name: GetUserFavorite :one
SELECT * FROM user_favorites
WHERE user_id = $1 AND file_id = $2
LIMIT 1;

-- name: ListUserFavorites :many
SELECT f.*
FROM files f
JOIN user_favorites uf ON f.id = uf.file_id
WHERE uf.user_id = $1
ORDER BY uf.added_at DESC;

-- name: AddUserFavorite :exec
INSERT INTO user_favorites (
    user_id,
    file_id
) VALUES (
    $1, $2
);

-- name: RemoveUserFavorite :exec
DELETE FROM user_favorites
WHERE user_id = $1 AND file_id = $2;

-- name: RemoveAllUserFavorites :exec
DELETE FROM user_favorites
WHERE user_id = $1;

-- name: CheckFileIsFavorite :one
SELECT EXISTS (
    SELECT 1 FROM user_favorites
    WHERE user_id = $1 AND file_id = $2
) AS is_favorite;
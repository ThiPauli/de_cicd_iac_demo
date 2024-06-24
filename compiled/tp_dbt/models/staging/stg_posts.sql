

WITH source_posts_data AS (
    SELECT * FROM
    (
        SELECT
            id,
            userId,
            title,
            body,
            input_file_name() AS file_name
        FROM
            json.`s3://teste-tp-terraform-bucket/raw/posts/*.json`
    )
)

SELECT * FROM source_posts_data
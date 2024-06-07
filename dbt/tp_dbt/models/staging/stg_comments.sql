{{ config(materialized='table') }}

WITH source_comments_data AS (
    SELECT * FROM
    (
        SELECT
            id,
            postId,
            name,
            email,
            body,
            input_file_name() AS file_name
        FROM
            json.`s3://teste-tp-terraform-bucket/raw/comments/*.json`
    )
)

SELECT * FROM source_comments_data

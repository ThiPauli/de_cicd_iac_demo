with posts as (
    select
        userId as post_user_id,
        id as post_id,
        title as post_title,
        body as post_body
    from
        {{ ref('stg_posts') }}
),
comments as (
    select
        postId as post_id,
        id as comment_id,
        name as comment_name,
        email as comment_user_email,
        body as comment_body
    from
        {{ ref('stg_comments') }}
)

select
    p.post_id,
    p.post_title,
    p.post_body,
    c.comment_id,
    c.comment_user_email
from
    posts p
inner join
    comments c on p.post_id = c.post_id

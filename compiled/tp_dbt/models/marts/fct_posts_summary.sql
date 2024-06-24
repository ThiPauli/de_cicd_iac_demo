-- This model aggregate the total comments and distinct users by posts
with view_posts_comments as (
    select
        *
    from
        `hive_metastore`.`tp_schema_views`.`v_posts_comments`
)

select
    vpc.post_id,
    count(vpc.comment_id) as total_comments,
    count(distinct vpc.comment_user_email) as total_distinct_users
from
    view_posts_comments vpc
group by
    vpc.post_id
-- This model aggregate the total distinct posts commented by user
with view_posts_comments as (
    select
        *
    from
        `hive_metastore`.`tp_schema_views`.`v_posts_comments`
)

select
    vpc.comment_user_email,
    count(distinct vpc.post_id) as total_distinct_posts_commented
from
    view_posts_comments vpc
group by
    vpc.comment_user_email

    
    

with child as (
    select postId as from_field
    from `hive_metastore`.`tp_schema_staging`.`stg_comments`
    where postId is not null
),

parent as (
    select id as to_field
    from `hive_metastore`.`tp_schema_staging`.`stg_posts`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



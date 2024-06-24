
    
    

select
    id as unique_field,
    count(*) as n_records

from `hive_metastore`.`tp_schema_staging`.`stg_comments`
where id is not null
group by id
having count(*) > 1



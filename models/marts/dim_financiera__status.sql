with 

source as (

    select * from {{ ref('int_financiera__loan') }}

),

final as (
    
    select distinct 
        status_id,
        status
    from source

)

select * from final
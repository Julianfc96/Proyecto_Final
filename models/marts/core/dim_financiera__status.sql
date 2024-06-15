with 

source as (

    select * from {{ ref('int_financiera__loan') }}

),

final as (
    
    select distinct 
        {{dbt_utils.generate_surrogate_key(['status'])}} as status_id,
        status
    from source

)

select * from final
with 

source as (

    select * from {{ ref('int_financiera__trans') }}

),

final as (
    
    select distinct 
        {{dbt_utils.generate_surrogate_key(['operation','trans_type'])}} as operation_id,
        operation, 
        trans_type
    from source

)

select * from final
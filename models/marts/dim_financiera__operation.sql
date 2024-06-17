with 

source as (

    select * from {{ ref('int_financiera__trans') }}

),

final as (
    
    select distinct 
        operation_id,
        operation, 
        operation_type
    from source

)

select * from final
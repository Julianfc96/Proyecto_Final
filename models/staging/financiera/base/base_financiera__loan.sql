with 

source as (

    select * from {{ source('financiera', 'loan') }}

),

renamed as (

    select
        loan_id,
        account_id,
        date as loan_create_at,
        amount as loan_amount,
        duration,
        payments,
        status,
        _fivetran_deleted as data_deleted,
        _fivetran_synced as date_load

    from source

)

select * from renamed

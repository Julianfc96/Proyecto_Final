with 

source as (
    select * from {{ source('financiera', 'trans') }}
),

renamed as (
    select
        trans_id,
        account_id,
        date as trans_date,
        type as operation_type,
        operation,
        amount,
        balance,
        k_symbol as trans_desc,
        bank,
        account as account_to,
        _fivetran_deleted as data_deleted,
        _fivetran_synced as date_load
    from source
)
select * from renamed
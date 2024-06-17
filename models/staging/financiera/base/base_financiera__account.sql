with 

source as (

    select * from {{ source('financiera', 'account') }}

),

renamed as (

    select
        account_id,
        district_id,
        frequency as statement_frequency,
        date as created_at,
       _fivetran_deleted as data_deleted,
        _fivetran_synced as date_load
    from source
)

select * from renamed

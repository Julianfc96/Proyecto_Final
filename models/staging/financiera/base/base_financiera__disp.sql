with 

source as (

    select * from {{ source('financiera', 'disp') }}

),

renamed as (

    select
        disp_id,
        client_id,
        account_id,
        type as account_user,
        _fivetran_deleted as data_deleted,
        _fivetran_synced as date_load

    from source

)

select * from renamed
order by disp_id

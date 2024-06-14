with 

source as (

    select * from {{ ref('base_financiera__loan') }}

),

renamed as (

    select
        loan_id,
        account_id,
        loan_create_at,
        loan_amount,
        duration,
        payments,
        CASE 
            WHEN status is not null then {{dbt_utils.generate_surrogate_key(['status'])}}
            else null 
        END AS status_id,
        CASE 
            WHEN status like 'A' then 'Contrato terminado, sin problemas'
            WHEN status like 'B' then 'Contrato terminado, préstamo no pagado'
            WHEN status like 'C' then 'Contrato en ejecución, pagos correctos'
            WHEN status like 'D' then 'Contrato en ejecución, cliente endeudado'
        END as status,
        data_deleted,
        date_load

    from source

)

select * from renamed

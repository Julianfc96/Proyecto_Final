{{
    codegen.generate_source(
        schema_name = 'SNOWFLAKE_DB_FINANCIERA',
        database_name = 'ALUMNO26_DEV_BRONZE_DB',
        table_names = ['account','card', 'client', 'disp', 'district', 'loan', 'order_financiera', 'trans'],
        generate_columns = True,
        include_descriptions=True,
        include_data_types=True,
        name='financiera',
        include_database=True,
        include_schema=True
        )
}}
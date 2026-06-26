-- created_at: 2026-06-26T06:27:33.551834937+00:00
-- finished_at: 2026-06-26T06:27:33.872216699+00:00
-- elapsed: 320ms
-- outcome: success
-- dialect: snowflake
-- node_id: not available
-- query_id: 01c54d43-000d-cef5-0000-b109000c046e
-- desc: execute adapter call
show terse schemas in database BANKING_DWH
    limit 10000
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:33.874644563+00:00
-- finished_at: 2026-06-26T06:27:34.037730772+00:00
-- elapsed: 163ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.stg_transactions
-- query_id: 01c54d43-000d-cf6b-0000-b109000cf5d2
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "BANKING_DWH"."STAGING" LIMIT 10000;
-- created_at: 2026-06-26T06:27:34.040136057+00:00
-- finished_at: 2026-06-26T06:27:34.262324813+00:00
-- elapsed: 222ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.stg_transactions
-- query_id: 01c54d43-000d-cf6b-0000-b109000cf5da
-- desc: execute adapter call
create or replace   view BANKING_DWH.STAGING.stg_transactions
  
  
  
  
  as (
    
WITH raw_source AS (
    SELECT raw_data FROM BANKING_DWH.RAW.raw_transactions
    WHERE raw_data:payload:after IS NOT NULL
)
SELECT
    raw_data:payload:after:txn_id::INT AS transaction_id,
    raw_data:payload:after:account_id::INT AS account_id,
    raw_data:payload:after:txn_type::VARCHAR(10) AS transaction_type,
    TRY_CAST(raw_data:payload:after:amount::VARCHAR AS FLOAT) AS transaction_amount,
    raw_data:payload:after:reference_number::VARCHAR(50) AS reference_number,
    TO_TIMESTAMP(raw_data:payload:after:txn_timestamp::NUMBER / 1000000) AS transaction_time,
    raw_data:payload:op::VARCHAR(5) AS cdc_operation
FROM raw_source
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.stg_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:34.264602255+00:00
-- finished_at: 2026-06-26T06:27:34.413692843+00:00
-- elapsed: 149ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cef5-0000-b109000c0482
-- desc: get_relation > list_relations call
SHOW OBJECTS IN SCHEMA "BANKING_DWH"."MARTS" LIMIT 10000;
-- created_at: 2026-06-26T06:27:34.416763596+00:00
-- finished_at: 2026-06-26T06:27:34.652296552+00:00
-- elapsed: 235ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cef5-0000-b109000c048e
-- desc: execute adapter call
create or replace  temporary view BANKING_DWH.marts.fct_transactions__dbt_tmp
  
  
  
  
  as (
    
WITH staged_data AS (
	SELECT * FROM BANKING_DWH.STAGING.stg_transactions)

SELECT 
	transaction_id, 
	account_id, 
	transaction_type, 
	transaction_amount, 
	reference_number, 
	transaction_time, 
cdc_operation FROM staged_data

  	WHERE transaction_time >= (SELECT DATEADD(day, -3, MAX(transaction_time)) FROM BANKING_DWH.marts.fct_transactions)


QUALIFY ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_time DESC) = 1
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.fct_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:34.653410547+00:00
-- finished_at: 2026-06-26T06:27:34.776196309+00:00
-- elapsed: 122ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cf6b-0000-b109000cf5ea
-- desc: execute adapter call
describe table BANKING_DWH.marts.fct_transactions__dbt_tmp
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.fct_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:34.771157987+00:00
-- finished_at: 2026-06-26T06:27:34.900239974+00:00
-- elapsed: 129ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cf6b-0000-b109000cf5ee
-- desc: execute adapter call
describe table BANKING_DWH.marts.fct_transactions
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.fct_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:34.901634816+00:00
-- finished_at: 2026-06-26T06:27:35.021672137+00:00
-- elapsed: 120ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cef5-0000-b109000c0496
-- desc: execute adapter call
describe table BANKING_DWH.marts.fct_transactions__dbt_tmp
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.fct_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:35.022945502+00:00
-- finished_at: 2026-06-26T06:27:35.140701136+00:00
-- elapsed: 117ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cef5-0000-b109000c049e
-- desc: execute adapter call
describe table "BANKING_DWH"."MARTS"."FCT_TRANSACTIONS"
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.fct_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:35.143123107+00:00
-- finished_at: 2026-06-26T06:27:35.280922015+00:00
-- elapsed: 137ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cf6b-0000-b109000cf5f6
-- desc: execute adapter call
-- back compat for old kwarg name
  
  begin
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.fct_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:35.281446680+00:00
-- finished_at: 2026-06-26T06:27:36.913513133+00:00
-- elapsed: 1.6s
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cf6b-0000-b109000cf602
-- desc: execute adapter call

    
        
            
            
            
            
        
    

    

    merge into BANKING_DWH.marts.fct_transactions as DBT_INTERNAL_DEST
        using BANKING_DWH.marts.fct_transactions__dbt_tmp as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.transaction_id = DBT_INTERNAL_DEST.transaction_id))

    
    when matched then update set
        "TRANSACTION_ID" = DBT_INTERNAL_SOURCE."TRANSACTION_ID","ACCOUNT_ID" = DBT_INTERNAL_SOURCE."ACCOUNT_ID","TRANSACTION_TYPE" = DBT_INTERNAL_SOURCE."TRANSACTION_TYPE","TRANSACTION_AMOUNT" = DBT_INTERNAL_SOURCE."TRANSACTION_AMOUNT","REFERENCE_NUMBER" = DBT_INTERNAL_SOURCE."REFERENCE_NUMBER","TRANSACTION_TIME" = DBT_INTERNAL_SOURCE."TRANSACTION_TIME","CDC_OPERATION" = DBT_INTERNAL_SOURCE."CDC_OPERATION"
    

    when not matched then insert
        ("TRANSACTION_ID", "ACCOUNT_ID", "TRANSACTION_TYPE", "TRANSACTION_AMOUNT", "REFERENCE_NUMBER", "TRANSACTION_TIME", "CDC_OPERATION")
    values
        ("TRANSACTION_ID", "ACCOUNT_ID", "TRANSACTION_TYPE", "TRANSACTION_AMOUNT", "REFERENCE_NUMBER", "TRANSACTION_TIME", "CDC_OPERATION")


/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.fct_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:36.913734160+00:00
-- finished_at: 2026-06-26T06:27:37.113468088+00:00
-- elapsed: 199ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cef5-0000-b109000c04a6
-- desc: execute adapter call

    commit
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.fct_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;
-- created_at: 2026-06-26T06:27:37.114948854+00:00
-- finished_at: 2026-06-26T06:27:37.251472572+00:00
-- elapsed: 136ms
-- outcome: success
-- dialect: snowflake
-- node_id: model.banking_dbt.fct_transactions
-- query_id: 01c54d43-000d-cef5-0000-b109000c04aa
-- desc: execute adapter call
drop view if exists BANKING_DWH.marts.fct_transactions__dbt_tmp cascade
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.banking_dbt.fct_transactions", "profile_name": "banking_dbt", "target_name": "dev"} */;

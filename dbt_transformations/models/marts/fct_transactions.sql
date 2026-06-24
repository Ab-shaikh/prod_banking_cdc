{{ config(materialized='incremental', 
	unique_key='transaction_id', 
	on_schema_change='append_new_columns') }}
WITH staged_data AS (
	SELECT * FROM {{ ref('stg_transactions') }})

SELECT 
	transaction_id, 
	account_id, 
	transaction_type, 
	transaction_amount, 
	reference_number, 
	transaction_time, 
cdc_operation FROM staged_data
{% if is_incremental() %}
  	WHERE transaction_time >= (SELECT DATEADD(day, -3, MAX(transaction_time)) FROM {{ this }})
{% endif %}

QUALIFY ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_time DESC) = 1
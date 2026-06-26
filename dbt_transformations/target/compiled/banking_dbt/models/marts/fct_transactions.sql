
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
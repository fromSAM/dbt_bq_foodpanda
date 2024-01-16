{{

    config(
        materialized='table'
    )
}}

SELECT
    COUNT(DISTINCT customer_id) AS total_customers_with_successful_orders
FROM
    Original_fp.Orders
WHERE
    is_successful_order = TRUE
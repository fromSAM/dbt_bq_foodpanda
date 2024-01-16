{{

    config(
        materialized='table'
    )
}}

SELECT
    COUNT(DISTINCT customer_id) AS customers_with_reorders
FROM
    Original_fp.Orders
WHERE
     date_local >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
{{

    config(
        materialized='table'
    )
}}

SELECT
    date_local AS order_date,
    COUNT(*) AS total_successful_orders
FROM
    Original_fp.Orders
WHERE
    is_successful_order = TRUE
GROUP BY
    date_local
{{

    config(
        materialized='table'
    )
}}


SELECT
    V.vendor_name,
    O.date_local AS order_date,
    COUNT(*) AS total_successful_orders
FROM
    Original_fp.Orders O
JOIN
    Original_fp.Vendors V ON O.vendor_id = V.id
WHERE
    O.is_successful_order = TRUE
GROUP BY
    V.vendor_name, O.date_local
# Motores
# MergeTree

# Aggregating Merge Tree

https://clickhouse.com/docs/engines/table-engines/mergetree-family/aggregatingmergetree

!!! warning " To insert data, use [INSERT SELECT](https://clickhouse.com/docs/sql-reference/statements/insert-into) query with aggregate -State- functions. When selecting data from `AggregatingMergeTree` table, use `GROUP BY` clause and the same aggregate functions as when inserting data, but using the `-Merge` suffix. "

- [ ] Raw Data table `ENGINE = MergeTree`
	- [ ] Normal datatypes
- [ ] Aggregated Data table `ENGINE = AggregatingMergeTree`
	- [ ] State datatypes
- [ ] Materialized view that populates Aggregated Data table 
	- [ ] `CREATE MATERIALIZED VIEW`
	- [ ] `TO <aggregated data table names>`
	- [ ] State datatypes
- [ ] Inserts
- [ ] Queries
	- [ ] Merge datatypes

!!! danger " Old data before inserts not taken into account "
>If the raw data table had elements before the creation of the Materialized view, it will not add it to the aggregated data table. you need a manual insert
>
>```SQL
>INSERT INTO etsiinf.aggEvents
>SELECT
>toStartOfHour(EventDate) AS EventDate,
>EventID,
>sumState(V1) AS sV1,
>avgState(V2) AS mV2,
>uniqState(V2) AS uV2
>FROM etsiinf.Events
>GROUP BY EventDate, EventID;
>```

# Summing Merge Tree

https://clickhouse.com/docs/engines/table-engines/mergetree-family/summingmergetree

```SQL
CREATE TABLE summtt  
(  
key UInt32,  
value UInt32  
)  
ENGINE = SummingMergeTree()  
ORDER BY key
```

```SQL
SELECT key, sum(value) FROM summtt GROUP BY key
```

!!! danger " ClickHouse can merge the data parts so that different resulting parts of data can consist rows with the same primary key, i.e. the summation will be incomplete. Therefore (`SELECT`) an aggregate function [sum()](https://clickhouse.com/docs/sql-reference/aggregate-functions/reference/sum) and `GROUP BY` clause should be used in a query as described in the example above. "


!!! warning " Can sum nested structures "

```SQL
OPTIMIZE TABLE nested_sum FINAL; -- emulate merge
```

# ReplacingMergeTree

https://clickhouse.com/docs/engines/table-engines/mergetree-family/replacingmergetree

https://clickhouse.com/docs/guides/replacing-merge-tree

!!! warning " Thus, `ReplacingMergeTree` is suitable for clearing out duplicate data in the background in order to save space, but it does not guarantee the absence of duplicates. "

Special Columns `ReplaceMergeTree(<name of column>, <name of column>)` :

- ver : if exists, the biggest stays, in not the las in the select stays
- is_deleted : if exists marks the row as deleted (1) or current state (0)

```SQL
-- with ver and is_deleted  
CREATE OR REPLACE TABLE myThirdReplacingMT  
(  
`key` Int64,  
`someCol` String,  
`eventTime` DateTime,  
`is_deleted` UInt8  
)  
ENGINE = ReplacingMergeTree(eventTime, is_deleted)  
ORDER BY key
```

!!! danger " FINAL "

At merge time, the ReplacingMergeTree identifies duplicate rows, using the values of the `ORDER BY` columns (used to create the table) as a unique identifier, and retains only the highest version. This, however, offers eventual correctness only - it does not guarantee rows will be deduplicated, and you should not rely on it. Queries can, therefore, produce incorrect answers due to update and delete rows being considered in queries.

To obtain correct answers, users will need to complement background merges with query time deduplication and deletion removal. This can be achieved using the `FINAL` operator. For example, consider the following example:

```SQL
SELECT count()  
FROM rmt_example  
FINAL
```

# CoalescingMergeTree

!!! danger " Replaces NULL "

!!! warning " This enables column-level upserts, meaning you can update only specific columns rather than entire rows. "

!!! danger " Using the `FINAL` modifier forces ClickHouse to apply merge logic at query time, ensuring you get the correct, coalesced "latest" value for each column. This is the safest and most accurate method when querying from a CoalescingMergeTree table. "

# CollapsingMergeTree

https://clickhouse.com/docs/engines/table-engines/mergetree-family/collapsingmergetree

!!! warning " The `CollapsingMergeTree` table engine asynchronously deletes (collapses) pairs of rows if all the fields in a sorting key (`ORDER BY`) are equivalent except for the special field `Sign`, which can have values of either `1` or `-1`. Rows without a pair of opposite valued `Sign` are kept "
 
Extra columns
- sign

Aggregation is required if there is a need to get completely "collapsed" data from the `CollapsingMergeTree` table. To finalize collapsing, write a query with the `GROUP BY` clause and aggregate functions that account for the sign. For example, to calculate quantity, use `sum(Sign)` instead of `count()`. To calculate the sum of something, use `sum(Sign * x)` together `HAVING sum(Sign) > 0` instead of `sum(x)` as in the [example](https://clickhouse.com/docs/engines/table-engines/mergetree-family/collapsingmergetree#example-of-use) below.

The aggregates `count`, `sum` and `avg` could be calculated this way. The aggregate `uniq` could be calculated if an object has at least one non-collapsed state. The aggregates `min` and `max` could not be calculated because `CollapsingMergeTree` does not save the history of the collapsed states.

```SQL
SELECT  
UserID,  
sum(PageViews * Sign) AS PageViews,  
sum(Duration * Sign) AS Duration  
FROM UAct  
GROUP BY UserID  
HAVING sum(Sign) > 0
```

!!! danger " If we do not need aggregation and want to force collapsing, we can also use the `FINAL` modifier for `FROM` clause. (LESS EFFICIENT) "



# Sobre examen

estaciones :
- csv
- json
- csv en local
- csv upd drive
- csv s3 minio
- mariadb
- parquet
- parquet local
- parquet url
- parquet s3

sakila_star en mariadb dockeriado

minio
mariadb
clickhouse


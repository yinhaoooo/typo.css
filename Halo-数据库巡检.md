# 数据库巡检

# 主机信息

## CPU

```bash
mpstat | sed -n '3,$p' | awk -F' ' '{print $13}'
echo 'CPU CORE' && cat /proc/cpuinfo|grep processor|wc -l
```

- 正常：空闲 cpu 大于 20%；
- 异常处理：排查问题，杀掉 cpu 高进程，top 按 c；

## 检查内存

```bash
free -m
```

- 正常：空闲内存大于 30%；
- 异常处理：排查问题，杀掉内存高进程，top 按 c；

## 检查磁盘空间

```bash
df -lh
```

- 正常：磁盘空间已用空间小于 70%；
- 异常处理：增加硬盘或者删除无用的数据；

## 检查 IO

```bash
iostat -x | sed -n '6,$p' | awk -F' ' '{print $1,$13,$14}'
```

- 正常：磁盘空间已用空间小于 70%；
- 异常处理：增加硬盘或者删除无用的数据；

## 检查端口

```bash
netstat -tanp | grep 'LISTEN' | grep '5432'
```

- 正常：tcp4 和 tcp6 正常监听；
- 异常处理：排查数据库是否正常启动，排查数据库配置文件的端口参数是否为 5432；

## 检查postgres进程

```bash
ps -ef | grep "checkpointer\|background writer\|walwriter\|autovacuum launcher\|archiver\|stats collector\|logical replication launcher\|logger" | grep -v grep
```

- 正常：进程都在；
- 异常处理：重启数据库；

# 数据库

## 检查安装信息

```bash
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,to_char(pg_postmaster_start_time(),'yyyy-mm-dd hh24:mi:ss') "pg_start_time(启动时间)"
    ,now()-pg_postmaster_start_time() "pg_running_time(运行时长)"
    --,inet_server_addr() "server_ip(服务器ip)"
    --,inet_server_port() "server_port(服务器端口)"
    --,inet_client_addr() "client_ip(客户端ip)"
    --,inet_client_port() "client_port(客户端端口)"
    ,version() "server_version(数据库版本)"
    ,(case when pg_is_in_recovery()='f' then 'primary' else 'standby' end ) as  "primary_or_standby(主或备)"
;
```

- 正常：数据库正常使用；
- 异常处理：重装数据库；

## 检查postgresql.conf 文件

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,sourceline "sourceline(行号)"
    ,name "para(参数名)"
    ,setting "value(参数值)"
from pg_file_settings
order by "sourceline(行号)";
```

- 正常：各项参数设置适合；
- 异常处理：编辑 postgresql.conf 文件，修改参数后重启数据库；

```bash
vi $PGDATA/postgresql.conf
pg_ctl restart -mf
```

## 检查 pg_hba.conf 文件

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,line_number "line_number(行号)"
    ,type "type(连接类型)"
    ,database "database(数据库名)"
    ,user_name "user_name(用户名)"
    ,address "address(ip地址)"
    ,netmask "netmask(子网掩码)"
    ,auth_method "auth_method(认证方式)"
from pg_hba_file_rules
order by "line_number(行号)";
```

- 正常：非套接字连接都需要 md5 认证；
- 异常处理：编辑 pg_hba.conf 文件，修改参数后重新加载数据库；

```bash
vi $PGDATA/postgresql.conf
pg_ctl reload
```

## 检查数据库重要配置

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,name
    ,setting
from
    pg_settings a
where a.name in (
  'data_directory',
  'port',
  'client_encoding',
  'config_file',
  'hba_file',
  'ident_file',
  'archive_mode',
  'logging_collector',
  'log_directory',
  'log_filename',
  'log_truncate_on_rotation',
  'log_statement',
  'log_min_duration_statement',
  'max_connections',
  'listen_addresses'
)
order by name;
```

- 正常：各项配置都适合；
- 异常处理：修改不合适的配置；

## 检查主从 WAl 状态

- 主

```sql
select
    -- pid "pid(进程id)"
    --,usename "username(用户名)"
    --,application_name "application_name(应用名)"
    --,client_addr "client_addr(IP)"
    --,backend_start "backend_start(备份开始时间)"
     state "state(WAL发送状态编码)"
--    ,case
--        when state = 'startup' then '正在启动'
--        when state = 'catchup' then '追赶主库'
--        when state = 'streaming' then '流传送'
--        when state = 'backup' then '发送备份'
--        when state = 'stopping' then '发送停止'
--     end "statename(WAL状态)"
    ,sync_state "sync_state(同步状态编码)"
--    ,case
--        when sync_state = 'async' then '异步'
--        when sync_state = 'potential' then '后备失效变同步'
--        when sync_state = 'sync' then '同步'
--        when sync_state = 'quorum' then '候选'
--     end "sync_statename(同步状态名称)"
    --,round(pg_wal_lsn_diff(pg_current_wal_lsn(),replay_lsn) /(1024 * 1024),2) as "slave_latency_mb(同步延迟_MB)"
from pg_stat_replication;
```

- 从

```sql
select
    -- pid "pid(进程id)"
     status "status(WAl接收状态)"
    ,'async' "sync_state(同步状态编码)"
    --,last_msg_send_time "last_msg_send_time(接收到最后的消息发送时间)"
    --,last_msg_receipt_time "last_msg_receipt_time(接收到最后的消息接收时间)"
    --,sender_host "sender_host(主库IP)"
from pg_stat_wal_receiver
;
```

## 检查表空间

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,spcname AS "Name(名称)"
    ,pg_catalog.pg_get_userbyid(spcowner) AS "Owner(拥有者)"
 ,pg_catalog.pg_size_pretty(pg_catalog.pg_tablespace_size(oid)) AS "Size(表空间大小)"
from pg_catalog.pg_tablespace
order by 1;
```

## 检查连接数

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,max_conn "max_conn(最大连接数)"
    ,now_conn "now_conn(当前连接数)"
    ,max_conn - now_conn "remain_conn(剩余连接数)"
from (
    select
         setting::int8 as max_conn
        ,(select count(*) from pg_stat_activity ) as now_conn
    from pg_settings
    where name = 'max_connections'
) a
;

```

- 正常：连接数不超过总连接数的 90%；
- 异常处理：超级用户（postgres）杀连接；

```sql
--杀掉所有空闲连接
select pg_terminate_backend(pid) from pg_stat_activity WHERE state = 'idle';

```

## 检查锁表

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,relname "relname(表名)"
    ,b.nspname "shemaname(模式名)"
    ,c.rolname "user(用户名)"
    ,d.locktype "locktype(被锁对象类型)"
    ,d.mode "mode(锁类型)"
    ,d.pid "pid(进程id)"
    ,e.query "query(锁表sql)"
    ,current_timestamp-state_change "lock_duration(锁表时长)"
from pg_class a
inner join pg_namespace b
on (a.relnamespace = b.oid)
inner join pg_roles c
on (a.relowner = c.oid)
inner join pg_locks d
on (a.oid = d.relation)
left join pg_stat_activity e
on (d.pid = e.pid)
where d.mode = 'AccessExclusiveLock'
order by "lock_duration(锁表时长)" desc;

```

- 正常：无锁表；
- 异常处理：取消该进程或杀掉该会话；

```sql
--取消该进程
select pg_cancel_backend(pid);
--杀掉该会话
select pg_terminate_backend(pid);
```

## 检查空闲连接 top5

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,a.datname "datname(数据库名)"
    ,a.pid "pid(进程id)"
    ,b.rolname "username(用户名)"
    --,a.application_name "app_name(应用名称)"
    ,a.client_addr "client_ip(客户端ip)"
    --,a.query_start "query_start(当前查询开始时间)"
    ,to_char(a.state_change,'yyyy-mm-dd hh24:mi:ss') "state_change(状态变化时间)"
    --,a.state "state(状态)"
    --,a.query "sql(执行的sql)"
    --,a.backend_type "backend_type(后端类型)"
from pg_stat_activity a
inner join pg_roles b
on (a.usesysid = b.oid)
where a.state = 'idle'
    and state_change < current_timestamp - interval '30 min'
order by current_timestamp-state_change desc
limit 5
;
```

- 正常：超半小时空闲的连接；
- 异常处理：杀连接；

```sql
select pg_terminate_backend(pid);

```

## 检查长事务 top5

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,a.datname "datname(数据库名)"
    ,a.pid "pid(进程id)"
    ,b.rolname "username(用户名)"
    --,a.application_name "app_name(应用名称)"
    ,a.client_addr "client_ip(客户端ip)"
    --,a.xact_start "xact_start(当前事务开始时间)"
    --,a.query_start "query_start(当前查询开始时间)"
    ,to_char(a.state_change,'yyyy-mm-dd hh24:mi:ss') "state_change(状态变化时间)"
    --,a.state "state(状态)"
    --,a.query "sql(执行的sql)"
    --,a.backend_type "backend_type(后端类型)"
from pg_stat_activity a
inner join pg_roles b
on (a.usesysid = b.oid)
where a.state in ('idle in transaction','idle in transaction (aborted)')
    and state_change < current_timestamp - interval '30 min'
order by current_timestamp-state_change desc
limit 5;

```

- 正常：不存在长事务；
- 异常处理：杀会话；

```sql
select pg_terminate_backend(pid);
1
```

## 检查慢 SQLtop5

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,a.datname "datname(数据库名)"
    ,a.pid "pid(进程id)"
    ,b.rolname "username(用户名)"
    --,a.application_name "app_name(应用名称)"
    ,a.client_addr "client_ip(客户端ip)"
    --,a.query_start "query_start(当前查询开始时间)"
    ,to_char(a.state_change,'yyyy-mm-dd hh24:mi:ss') "state_change(状态变化时间)"
    --,a.wait_event_type "wait_event_type(等待类型)"
    --,a.wait_event "wait_event(等待事件)"
    --,a.state "state(状态)"
    --,a.query "sql(执行的sql)"
    --,a.backend_type "backend_type(后端类型)"
from pg_stat_activity a
left join pg_roles b
on (a.usesysid = b.oid)
where a.state = 'active'
    and state_change < current_timestamp - interval '1 hour'
    and a.datname is not null
order by current_timestamp-state_change desc
limit 5;
```

- 正常：不存在慢 sql；
- 异常处理：分析原因，有针对性地杀连接；

```sql
select pg_terminate_backend(pid);
```

## 检查对象数

```sql
--这里需要循环查每个库所有数据然后合并
select to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,current_database()
    ,sum(obj_num) "obj_num(对象数)"
from (
    select count(1) obj_num from pg_class
    union all
    select count(1) from pg_proc
) a
;
```

- 正常：总对象数不超过 5 万；
- 异常处理：删除无用的对象；

## 检查表膨胀 top5

```sql
select
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,current_database() current_database
    ,relname as "table_name(表名)"
    ,schemaname as "schema_name(模式名)"
    ,pg_size_pretty(pg_relation_size('"'||schemaname|| '"."'||relname||'"')) as "table_size(表大小)"
    ,n_dead_tup as "n_dead_tup(无效记录数)"
    ,n_live_tup as "n_live_tup(有效记录数)"
    ,to_char(round(n_dead_tup*1.0/(n_live_tup+n_dead_tup)*100,2),'fm990.00') as "dead_rate(无效记录比例%)"
from
    pg_stat_all_tables
where n_live_tup+n_dead_tup <> 0
;

select                       
     to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间"
    ,current_database() current_database 
    ,relname as "table_name(表名)"
    ,schemaname as "schema_name(模式名)"
    ,pg_size_pretty(pg_relation_size('"'||schemaname|| '"."'||relname||'"')) as "table_size(表大小)"
    ,n_dead_tup as "n_dead_tup(无效记录数)"
    ,n_live_tup as "n_live_tup(有效记录数)"
    ,to_char(round(n_dead_tup*1.0/(n_live_tup+n_dead_tup)*100,2),'fm990.00') as "dead_rate(无效记录比例%)"
from
    pg_stat_user_tables
where n_dead_tup <> 0         
;
```

- 正常：不存在表膨胀，因为有自动清理垃圾进程；
- 异常处理：对膨胀表做 vacuum analyze 操作；

## 检查索引膨胀

```sql
select
  to_char(now(),'yyyy-mm-dd hh24:mi:ss') "巡检时间",
  current_database() AS db, schemaname, tablename,bs, reltuples::bigint AS tups, relpages::bigint AS pages, otta,
  ROUND(CASE WHEN otta=0 OR sml.relpages=0 OR sml.relpages=otta THEN 0.0 ELSE sml.relpages/otta::numeric END,1) AS tbloat,
  CASE WHEN relpages < otta THEN 0 ELSE relpages::bigint - otta END AS wastedpages,
  CASE WHEN relpages < otta THEN 0 ELSE bs*(sml.relpages-otta)::bigint END AS wastedbytes,
  CASE WHEN relpages < otta THEN $$0 bytes$$::text ELSE (bs*(relpages-otta))::bigint || $$ bytes$$ END AS wastedsize,
  iname, ituples::bigint AS itups, ipages::bigint AS ipages, iotta,
  ROUND(CASE WHEN iotta=0 OR ipages=0 OR ipages=iotta THEN 0.0 ELSE ipages/iotta::numeric END,1) AS ibloat,
  CASE WHEN ipages < iotta THEN 0 ELSE ipages::bigint - iotta END AS wastedipages,
  CASE WHEN ipages < iotta THEN 0 ELSE bs*(ipages-iotta) END AS wastedibytes,
  CASE WHEN ipages < iotta THEN $$0 bytes$$ ELSE (bs*(ipages-iotta))::bigint || $$ bytes$$ END AS wastedisize,
  CASE WHEN relpages < otta THEN
    CASE WHEN ipages < iotta THEN 0 ELSE bs*(ipages-iotta::bigint) END
    ELSE CASE WHEN ipages < iotta THEN bs*(relpages-otta::bigint)
      ELSE bs*(relpages-otta::bigint + ipages-iotta::bigint) END
  END AS totalwastedbytes
FROM (
  SELECT
    nn.nspname AS schemaname,
    cc.relname AS tablename,
    COALESCE(cc.reltuples,0) AS reltuples,
    COALESCE(cc.relpages,0) AS relpages,
    COALESCE(bs,0) AS bs,
    COALESCE(CEIL((cc.reltuples*((datahdr+ma-
      (CASE WHEN datahdr%ma=0 THEN ma ELSE datahdr%ma END))+nullhdr2+4))/(bs-20::float)),0) AS otta,
    COALESCE(c2.relname,$$?$$) AS iname, COALESCE(c2.reltuples,0) AS ituples, COALESCE(c2.relpages,0) AS ipages,
    COALESCE(CEIL((c2.reltuples*(datahdr-12))/(bs-20::float)),0) AS iotta -- very rough approximation, assumes all cols
  FROM
     pg_class cc
  JOIN pg_namespace nn ON cc.relnamespace = nn.oid AND nn.nspname <> $$information_schema$$
  LEFT JOIN
  (
    SELECT
      ma,bs,foo.nspname,foo.relname,
      (datawidth+(hdr+ma-(case when hdr%ma=0 THEN ma ELSE hdr%ma END)))::numeric AS datahdr,
      (maxfracsum*(nullhdr+ma-(case when nullhdr%ma=0 THEN ma ELSE nullhdr%ma END))) AS nullhdr2
    FROM (
      SELECT
        ns.nspname, tbl.relname, hdr, ma, bs,
        SUM((1-coalesce(null_frac,0))*coalesce(avg_width, 2048)) AS datawidth,
        MAX(coalesce(null_frac,0)) AS maxfracsum,
        hdr+(
          SELECT 1+count(*)/8
          FROM pg_stats s2
          WHERE null_frac<>0 AND s2.schemaname = ns.nspname AND s2.tablename = tbl.relname
        ) AS nullhdr
      FROM pg_attribute att
      JOIN pg_class tbl ON att.attrelid = tbl.oid
      JOIN pg_namespace ns ON ns.oid = tbl.relnamespace
      LEFT JOIN pg_stats s ON s.schemaname=ns.nspname
      AND s.tablename = tbl.relname
      AND s.inherited=false
      AND s.attname=att.attname,
      (
        SELECT
          (SELECT current_setting($$block_size$$)::numeric) AS bs,
            CASE WHEN SUBSTRING(SPLIT_PART(v, $$ $$, 2) FROM $$#"[0-9]+.[0-9]+#"%$$ for $$#$$)
              IN ($$8.0$$,$$8.1$$,$$8.2$$) THEN 27 ELSE 23 END AS hdr,
          CASE WHEN v ~ $$mingw32$$ OR v ~ $$64-bit$$ THEN 8 ELSE 4 END AS ma
        FROM (SELECT version() AS v) AS foo
      ) AS constants
      WHERE att.attnum > 0 AND tbl.relkind=$$r$$
      GROUP BY 1,2,3,4,5
    ) AS foo
  ) AS rs
  ON cc.relname = rs.relname AND nn.nspname = rs.nspname
  LEFT JOIN pg_index i ON indrelid = cc.oid
  LEFT JOIN pg_class c2 ON c2.oid = i.indexrelid
) AS sml
;
```

- 索引膨胀，依赖于统计信息，统计信息未更新，索引膨胀信息不准确。一般每年统一做一次重建索引即可。
- 异常处理：重建索引；

```sql
reindex index 索引名;
```

## 查看当前数据库表的年龄

```sql
select current_database()
,rolname,nspname
,relkind
,relname
,age(relfrozenxid)
,2^31-age(relfrozenxid) age_remain 
from pg_authid t1 
    join pg_class t2 
        on t1.oid=t2.relowner 
    join pg_namespace t3 
        on t2.relnamespace=t3.oid 
where t2.relkind in ($$t$$,$$r$$) 
order by age(relfrozenxid) 
desc limit 5
;

```

## 查看全库对象统计

```sql
select    nsp.nspname as SchemaName    ,case cls.relkind        when 'r' then 'TABLE'        when 'm' then 'MATERIALIZED_VIEW'        when 'i' then 'INDEX'        when 'S' then 'SEQUENCE'        when 'v' then 'VIEW'        when 'c' then 'composite type'        when 't' then 'TOAST'        when 'f' then 'foreign table'        when 'p' then 'partitioned_table'        when 'I' then 'partitioned_index'        else cls.relkind::text    end as ObjectType,    COUNT(*) cnt from pg_class cls join pg_namespace nsp on nsp.oid = cls.relnamespace where nsp.nspname not in ('information_schema', 'pg_catalog')  and nsp.nspname not like 'pg_toast%'GROUP BY nsp.nspname,cls.relkind UNION all SELECT n.nspname as "Schema", CASE p.prokind  WHEN 'a' THEN 'agg'  WHEN 'w' THEN 'window'  WHEN 'p' THEN 'proc'  ELSE 'func' END as "Type", COUNT(*) cnt FROM pg_catalog.pg_proc p LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace WHERE pg_catalog.pg_function_is_visible(p.oid)AND n.nspname not in ('information_schema', 'pg_catalog')GROUP BY n.nspname ,p.prokind;

```


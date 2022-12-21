-- hook-holder-hourly
with
  transfers as (
    select
      time,
      address,
      token_address,
      sum(amount) as amount
    from
      (
        select
          date_trunc('hour', evt_block_time) as time,
          `to` as address,
          contract_address as token_address,
          value as amount
        from
          hookedprotocal_bnb.HookToken_evt_Transfer
        union all
        select
          date_trunc('hour', evt_block_time) as time,
          `from` as address,
          contract_address as token_address,
          -1 * value as amount
        from
          hookedprotocal_bnb.HookToken_evt_Transfer
      )
    group by
      1,
      2,
      3
  ),
  balance_over_time as (
    select
      time,
      address,
      sum(amount) over (
        partition by
          address
        order by
          time
      ) as balance,
      lead(time, 1, now()) over (
        partition by
          address
        order by
          time
      ) as next_time
    from
      transfers
  ),
  time_list as (
    select
      explode (
        sequence(
          to_date('2022-11-30'),
          date_trunc('hour', now()),
          interval 1 hour
        )
      ) as time
  ),
  address_by_time as (
    select
      t.time,
      address,
      sum(balance) as balance
    from
      balance_over_time b
      inner join time_list t on b.time <= t.time
      and t.time < b.next_time
    group by
      1,
      2
    order by
      1,
      2
  )
select
  time,
  count(address) as holder_amount,
  count(address) - lag(count(address)) over (
    order by
      time
  ) as change
from
  address_by_time
where
  balance > 0
group by
  1
order by
  1;
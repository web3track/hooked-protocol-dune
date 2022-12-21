-- hook-airdrop-in-out
with
  senders (address) as (
    values
      '0x6e68a7ece5e8045f7c91134cf51b7eae91d7a5bc',
      '0xdc96113a233c821a3beaac5d4f0be3e85cf4175f',
      '0x1b31946f93ef39db67b2568428087447c80d8fce',
      '0xa9ec3fb1bd88d7e5d09786cd66d638ef514987d8',
      '0x8ed8d00fd4f2cf61fb9141fcf31e110517ab216f',
      '0xe6f49a77ccf4322c27740171dd2cc290ff78bf30',
      '0x92a9ea5e6506600fe24901f462d979d96f6bc7f4',
      '0xa307871d711a7a012ba2e176fffd9db49a02db5e',
      '0xc8cac0235c657cc00bd9a1d5f6695e499e5ce7d3',
      '0x0bae758b616653bcdf395994035f1a0a853721a5'
  ),
  outflow as (
    select
      sum(tr.value / 1e18) as value,
      date_trunc('hour', tr.evt_block_time) as hour
    from
      hookedprotocal_bnb.HookToken_evt_Transfer tr
      inner join hookedprotocal_bnb.HPPNFT_evt_Transfer hpp on tr.`from` = hpp.`to`
    where
      tr.`from` not in (
        select
          address
        from
          senders
      )
    group by
      date_trunc('hour', tr.evt_block_time)
    order by
      date_trunc('hour', tr.evt_block_time)
  ),
  inflow as (
    select
      sum(tr.value / 1e18) as value,
      date_trunc('hour', tr.evt_block_time) as hour
    from
      hookedprotocal_bnb.HookToken_evt_Transfer tr
      inner join hookedprotocal_bnb.HPPNFT_evt_Transfer hpp on tr.`to` = hpp.`to`
    where
      tr.`to` not in (
        select
          address
        from
          senders
      )
    group by
      date_trunc('hour', tr.evt_block_time)
    order by
      date_trunc('hour', tr.evt_block_time)
  )
select
  inflow.hour as hour,
  inflow.value as in,
  outflow.value as out
from
  inflow
  left join outflow on inflow.hour = outflow.hour
order by
  inflow.hour
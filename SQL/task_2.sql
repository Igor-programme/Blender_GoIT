select
ad_date
, campaign_id
, sum(spend) as total_spend
, sum(impressions) as total_impressions
, sum(clicks) as total_clicks
, sum(value) as total_value
, case when sum(clicks) > 0 then round(sum(spend::numeric) / sum(clicks), 2)
 end as cpc
 , case when sum(impressions) > 0 then
 sum(spend) / sum(impressions) *1000 end as CPM
 , case when sum(impressions) > 0 then
 sum(clicks::numeric) / sum(impressions) * 100 end as ctr
 , case when sum(spend) > 0 then
 (sum(value::numeric) - sum(spend)) / sum(spend) * 100 end as romi1
 , case when sum(spend) > 0 then
 (sum(value::numeric) / sum(spend) - 1) *100 end as romi2
from facebook_ads_basic_daily
group by ad_date
, campaign_id

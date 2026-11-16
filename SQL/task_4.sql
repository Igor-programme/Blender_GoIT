--Задача 5

with all_data as (select
ad_date
, 'Facebook Ads' as media_source
, campaign_name
, adset_name
, url_parameters
, spend, impressions, reach, clicks, leads, value
from facebook_ads_basic_daily fabd
left join facebook_campaign fc on fc.campaign_id = fabd.campaign_id
left join facebook_adset using (adset_id)
union all
select
ad_date
, 'Google Ads' as media_source
, campaign_name
, adset_name
, url_parameters
, spend, impressions, reach, clicks, leads, value
from google_ads_basic_daily),
full_data as (select
ad_date
, media_source
, campaign_name
, adset_name
, case when lower(substring(url_parameters, 'utm_campaign=([^&]+)')) = 'nan' then null
else lower(substring(url_parameters, 'utm_campaign=([^&]+)')) end
as utm_campaign
, coalesce(spend, 0) as spend
, coalesce(impressions, 0) as impressions
, coalesce(reach, 0) as reach
, coalesce(clicks, 0) as clicks
, coalesce(leads, 0) as leads
, coalesce(value, 0) as value
from all_data)
select
ad_date
, utm_campaign
, sum(spend) as total_spend
, sum(impressions) as total_impressions
, sum(clicks) as total_clicks
, sum(value) as total_value
, case when sum(impressions) > 0
then sum(clicks::numeric) / sum(impressions) *100 end as ctr
, case when sum(clicks) > 0
then sum(spend::numeric) / sum(clicks) end as cpc
, case when sum(impressions) > 0
then sum(spend::numeric) / sum(impressions) * 1000 end as cpm
, case when sum(spend) > 0 then
(sum(value::numeric) - sum(spend)) / sum(spend) * 100 end as romi
from full_data
group by ad_date
, utm_campaign

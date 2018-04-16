--Create Table 1
-- CREATE TABLE public.XU_XUEJUN_EIA_PP
-- (
--     utility_id int,
--     plant_code int,
--     prime_mover text ,
--     energy_source_1 text ,
--     utility_name text ,
--     technology text ,
--     plant_name text ,
--     nameplate_capacity numeric,
--     operating_year_avg numeric,
--     operating_year_max numeric,
--     operating_year_min numeric,
--     nerc_region text ,
--     net_generation_mwh numeric,
--     elec_fuel_consumption_mmbtu numeric,
--     capacity_factor numeric,
--     heat_rate varchar(50),
--     year int
-- );

--Create Table 2
-- CREATE TABLE public.XU_XUEJUN_EIA_LOC(
--     Plant_ID int,
--     Latitude numeric,
--     Longitude numeric,
--     Balancing_Authority_Code varchar(50)
--     );

--Import data into table 1 and table 2

--Merge table on Plant ID/Plant Code, and return data that includes\
--Plant ID, Technology, Nameplate capacity, latitude, and longitude.

--Create a new table to store the merged table

select Plant_ID, Technology, nameplate_capacity, latitude, longitude
from XU_XUEJUN_EIA_PP join XU_XUEJUN_EIA_LOC
on XU_XUEJUN_EIA_PP.plant_code=XU_XUEJUN_EIA_LOC.Plant_ID;

--Give access to joshdr to the 3 tables created
GRANT SELECT ON public.XU_XUEJUN_EIA_PP TO joshdr;
GRANT SELECT ON public.XU_XUEJUN_EIA_LOC TO joshdr;
GRANT SELECT ON public.XU_XUEJUN_EIA_MERGED TO joshdr;


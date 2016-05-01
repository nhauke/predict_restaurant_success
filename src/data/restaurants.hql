SET mapred.input.di.recursive=true;
SET hive.mapred.supports.subdirectories=true;
SET hive.groupby.orderby.position.alias=true;

ADD JAR /home/hadoop/Yelp/json-serde-1.3.7-jar.jar;

CREATE EXTERNAL TABLE IF NOT EXISTS restaurants (
  business_id string,
  zipcode string,
  hours struct<Monday:struct<open:string,
                             close:string>,
               Tuesday:struct<open:string,
                             close:string>,
               Wednesday:struct<open:string,
                             close:string>,
               Thursday:struct<open:string,
                             close:string>,
               Friday:struct<open:string,
                            close:string>,
               Saturday:struct<open:string,
                             close:string>,
               Sunday:struct<open:string,
                             close:string>>,
  open boolean,
  review_count int,
  name string,
  stars string,
  latitude string,
  longitude string,
  attributes struct<Takeout:boolean,
                    DriveThru:boolean,
                    GoodFor:struct<dessert:boolean,
                                   latenight:boolean,
                                   lunch:boolean,
                                   dinner:boolean,
                                   brunch:boolean,
                                   breakfast:boolean>,
                    Caters:boolean,
                    TakesReservation:boolean,
                    Delivery:boolean,
                    Ambience:struct<romantic:boolean,
                                    intimate:boolean,
                                    classy:boolean,
                                    hipster:boolean,
                                    divey:boolean,
                                    touristy:boolean,
                                    trendy:boolean,
                                    upscale:boolean,
                                    casual:boolean>,
                    Parking:struct<garage:boolean,
                                   street:boolean,
                                   validated:boolean,
                                   lot:boolean,
                                  valet:boolean>,
		    HasTV:boolean,
                    OutdoorSeating:boolean,
                    WaiterService:boolean,
                    AcceptsCreditCards:boolean,
                    GoodForKids:boolean,
                    GoodForGroups:boolean,
                    PriceRange:int>
  )
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' 
STORED AS TEXTFILE
LOCATION 's3://gu-anly502-yelp/restaurant_table/';

CREATE TABLE IF NOT EXISTS trunc_rest AS
SELECT business_id,
       zipcode,
       open,
       review_count,
       name,
       stars,
       latutude,
       longitude,
       attributes.PriceRange,
       if(attributes.GoodForKids,1,0) as GoodForKids,
       if(attributes.GoodForGroups,1,0) as GoodForGroup,
       if(attributes.GoodFor.dessert,1,0) as GoodForDessert,
       if(attributes.GoodFor.latenight,1,0) as GoodForLateNight,
       if(attributes.GoodFor.lunch,1,0) as GoodForLunch,
       if(attributes.GoodFor.dinner,1,0) as GoodForDinner,
       if(attributes.GoodFor.brunch,1,0) as GoodForBrunch,
       if(attributes.GoodFor.breakfast,1,0) as GoodForBreakfast,
       if(attributes.Ambience.romantic,1,0) as Romantic,
       if(attributes.Ambience.intimate,1,0) as Intimate,
       if(attributes.Ambience.classy,1,0) as Classy,
       if(attributes.Ambience.hipster,1,0) as Hipster,
       if(attributes.Ambience.divey,1,0) as Divey,
       if(attributes.Ambience.touristy,1,0) as Touristy,
       if(attributes.Ambience.trendy,1,0) as Trendy,
       if(attributes.Ambience.upscale,1,0) as Upscale,
       if(attributes.Ambience.casual,1,0) as Casual
FROM restaurants;


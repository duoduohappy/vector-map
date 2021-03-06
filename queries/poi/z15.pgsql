SELECT
  way AS __geometry__,
  name,
  (
    CASE
    WHEN amenity = 'fuel'
      THEN 'fuel'
    WHEN amenity = 'place_of_worship'
      THEN 'place_of_worship'

    WHEN man_made = 'tower' and "tower:type" is not null and tourism in ('attraction', 'viewpoint', 'museum') and coalesce(access, 'yes') != 'no'
      THEN 'marker' -- TODO: tower

    WHEN tourism = 'attraction' and "attraction:type" = 'hiking_route'
      THEN 'marker' -- TODO: hiking route
    WHEN tourism = 'information'
      THEN 'information'
    WHEN tourism in ('camp_site', 'caravan_site')
      THEN 'campsite'
    WHEN tourism in ('chalet', 'hostel', 'motel', 'guest_house')
      THEN 'home' -- TODO: split, fix icon
    WHEN tourism = 'hotel'
      THEN 'lodging'
    WHEN tourism = 'museum'
      THEN 'museum'
    WHEN tourism = 'picnic_site'
      THEN 'picnic_site'
    WHEN tourism = 'viewpoint'
      THEN 'viewpoint'

    WHEN historic = 'archaeological_site' and site_type = 'fortification'
      THEN 'hillfort'
    WHEN historic in ('monument', 'memorial')
      THEN 'marker' -- TODO: memorial
    WHEN historic = 'archaeological_site' and site_type = 'tumulus'
      THEN 'tumulus'
    WHEN historic = 'manor'
      THEN 'marker' -- TODO: manor
    WHEN historic = 'monastery'
      THEN 'marker' -- TODO: monastery

    WHEN tourism = 'attraction'
      THEN 'attraction'
    END
  ) AS kind,
  official_name,
  alt_name,
  opening_hours,
  website,
  image,
  "ref:lt:kpd" AS heritage,
  height,
  wikipedia,
  fee,
  email,
  phone,
  "addr:city" AS city,
  "addr:street" AS street,
  "addr:housenumber" AS housenumber
FROM
  planet_osm_point
WHERE
  way && !bbox! AND
  (
    amenity IN ('fuel',
                'place_of_worship') OR
    tourism IN ('attraction',
                'camp_site',
                'caravan_site',
                'chalet',
                'hostel',
                'motel',
                'guest_house',
                'hotel',
                'museum',
                'picnic_site',
                'viewpoint') OR
    (tourism = 'information' and information = 'office') OR
    historic IN ('archaeological_site',
                 'monument',
                 'memorial',
                 'manor',
                 'monastery')
  )

UNION ALL

SELECT
  st_centroid(way) AS __geometry__,
  name,
  (
    CASE
    WHEN amenity = 'fuel'
      THEN 'fuel'
    WHEN amenity = 'place_of_worship'
      THEN 'place_of_worship'

    WHEN man_made = 'tower' and "tower:type" is not null and tourism in ('attraction', 'viewpoint', 'museum') and coalesce(access, 'yes') != 'no'
      THEN 'marker' -- TODO: tower

    WHEN tourism = 'attraction' and "attraction:type" = 'hiking_route'
      THEN 'marker' -- TODO: hiking route
    WHEN tourism = 'information'
      THEN 'information'
    WHEN tourism in ('camp_site', 'caravan_site')
      THEN 'campsite'
    WHEN tourism in ('chalet', 'hostel', 'motel', 'guest_house')
      THEN 'home' -- TODO: split, fix icon
    WHEN tourism = 'hotel'
      THEN 'lodging'
    WHEN tourism = 'museum'
      THEN 'museum'
    WHEN tourism = 'picnic_site'
      THEN 'picnic_site'
    WHEN tourism = 'viewpoint'
      THEN 'viewpoint'

    WHEN historic = 'archaeological_site' and site_type = 'fortification'
      THEN 'marker' -- TODO: hillfort
    WHEN historic in ('monument', 'memorial')
      THEN 'marker' -- TODO: memorial
    WHEN historic = 'archaeological_site' and site_type = 'tumulus'
      THEN 'marker' -- TODO: tumulus
    WHEN historic = 'manor'
      THEN 'marker' -- TODO: manor
    WHEN historic = 'monastery'
      THEN 'marker' -- TODO: monastery

    WHEN tourism = 'attraction'
      THEN 'attraction'

    WHEN leisure = 'park'
      THEN 'park'

    END
  ) AS kind,
  official_name,
  alt_name,
  opening_hours,
  website,
  image,
  "ref:lt:kpd" AS heritage,
  height,
  wikipedia,
  fee,
  email,
  phone,
  "addr:city" AS city,
  "addr:street" AS street,
  "addr:housenumber" AS housenumber
FROM
  planet_osm_polygon
WHERE
  way && !bbox! AND
  (
    amenity IN ('fuel',
                'place_of_worship') OR
    tourism IN ('attraction',
                'camp_site',
                'caravan_site',
                'chalet',
                'hostel',
                'motel',
                'guest_house',
                'hotel',
                'museum',
                'picnic_site',
                'viewpoint') OR
    (tourism = 'information' and information = 'office') OR
    historic IN ('archaeological_site',
                 'monument',
                 'memorial',
                 'manor',
                 'monastery') OR
    leisure = 'park'
  )
